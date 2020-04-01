REPO=alpin3
NAME=ulx3s
IMAGE=$(REPO)/$(NAME)
OSTYPE=$(shell uname -s | tr '[A-Z]' '[a-z]')
MACHINE=$(shell uname -m)
ARCH=$(OSTYPE)-$(MACHINE)
VERSION=$(shell date '+%Y.%m.%d')
IMAGEVERSION=$(IMAGE):v$(VERSION)

ver:
	echo $(IMAGE) version $(VERSION)

build:
	docker build -t $(IMAGE):v$(VERSION) .

push:
	docker push $(IMAGE):v$(VERSION)

pull:
	docker pull $(IMAGE):v$(VERSION)

latest:
	docker tag $(IMAGE):v$(VERSION) $(IMAGE):latest

pushlatest:
	docker push $(IMAGE):latest

gittag:
	git tag v$(VERSION)

pushtags:
	git push --tags origin master

gitappimage:
	git clone https://github.com/kost/ulx3s-appimage

bins:
	mkdir -p dist
	mkdir -p $(NAME)-$(VERSION)-$(ARCH)
	docker run -it --name $(NAME)-$(VERSION) $(IMAGEVERSION) true
	docker cp $(NAME)-$(VERSION):/usr/local/bin $(NAME)-$(VERSION)-$(ARCH)/
	docker cp $(NAME)-$(VERSION):/opt/ghdl $(NAME)-$(VERSION)-$(ARCH)/
	docker cp $(NAME)-$(VERSION):/usr/local/share $(NAME)-$(VERSION)-$(ARCH)/
	tar -cvz --owner root --group root -f dist/$(NAME)-$(VERSION)-$(ARCH).tar.gz $(NAME)-$(VERSION)-$(ARCH)
	docker rm $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)-$(ARCH)

cpbins:
	docker run -it --name $(NAME)-$(VERSION) $(IMAGEVERSION) true
	docker cp $(NAME)-$(VERSION):/usr/local/bin $(NAME)-$(VERSION)-$(ARCH)
	docker rm $(NAME)-$(VERSION)

clean:
	rm -rf dist work

rel:
	ghr v$(VERSION) dist/

draft:
	ghr -draft v$(VERSION) dist/
