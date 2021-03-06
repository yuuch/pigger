.PHONY: all release

VER=test

all:
	@echo "[+] Install to local ..."
	@packr
	@go install
	@packr clean
	@echo "All is done!"

release:
	@echo "[+] Install to local ..."
	@packr
	@go install
	@echo "[+] Cross compile for linux, windows and mac ..."
	@gox -output="release/{{.Dir}}_{{.OS}}_{{.Arch}}-$(VER)" -os="linux windows darwin" -arch="amd64 386"
	@packr clean
	@echo "All is done!"
