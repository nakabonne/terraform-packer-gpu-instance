UNAME := $(shell uname)

./bin/packer:
	@mkdir -p bin
ifeq ($(UNAME), Linux)
	cd bin && curl -o packer.zip https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip && unzip packer.zip && rm packer.zip
	@chmod +x ./bin/packer
else ifeq ($(UNAME), Darwin)
  # Download ARM version
	cd bin && curl -o packer.zip https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_darwin_arm64.zip && unzip packer.zip && rm packer.zip
	@chmod +x ./bin/packer
else
	@echo "Unsupported OS, please copy your local packer binary manually to ./bin/packer"
	@exit 1
endif
