REPO=alpin3
NAME=ulx3s
IMAGE=$(REPO)/$(NAME)
OSTYPE=$(shell uname -s | tr '[A-Z]' '[a-z]')
MACHINE=$(shell uname -m)
ARCH=$(OSTYPE)-$(MACHINE)
VERSION=$(shell date '+%Y.%m.%d')

ver:
	echo $(IMAGE) version $(VERSION)

build:
	docker build -t $(IMAGE):v$(VERSION) .

push:
	docker push $(IMAGE):v$(VERSION)

latest:
	docker tag $(IMAGE):v$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest

gittag:
	git tag v$(VERSION)
	git push --tags origin master

bins:
	docker run -it --name $(NAME)-$(VERSION) $(IMAGE) true
	docker cp $(NAME)-$(VERSION):/usr/local/bin $(NAME)-$(VERSION)-$(ARCH)
	docker cp $(NAME)-$(VERSION):/opt/ghdl $(NAME)-ghdl-$(VERSION)-$(ARCH)
	tar -cvz --owner root --group root -f $(NAME)-$(VERSION)-$(ARCH).tar.gz $(NAME)-$(VERSION)-$(ARCH)
	tar -cvz --owner root --group root -f $(NAME)-ghdl-$(VERSION)-$(ARCH).tar.gz $(NAME)-ghdl-$(VERSION)-$(ARCH)
	docker rm $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)-$(ARCH) $(NAME)-ghdl-$(VERSION)-$(ARCH)

