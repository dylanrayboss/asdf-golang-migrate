#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for golang-migrate.
GH_REPO="https://github.com/golang-migrate/migrate"
TOOL_NAME="golang-migrate"
TOOL_TEST="migrate -version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if golang-migrate is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if golang-migrate has other means of determining installable versions.
	list_github_tags
}

get_platform() {
	local platform
	platform=$(uname)
	case $platform in
	Darwin) platform="darwin" ;;
	Linux) platform="linux" ;;
	Windows) platform="windows" ;;
	esac
	echo "$platform"
}

get_system_architecture() {
	local architecture
	architecture=$(uname -m)
	case $architecture in
	armv7l) architecture="armv7" ;;
	aarch64) architecture="arm64" ;;
	i386) architecture="386" ;;
	x86_64) architecture="amd64" ;;
	esac
	echo "$architecture"
}

get_file_extension() {
	local extension
	platform="$1"
	case $platform in
	darwin) extension="tar.gz" ;;
	linux) extension="tar.gz" ;;
	windows) extension="zip" ;;
	esac
	echo "$extension"
}

download_release() {
	local version platform architecture extension filename url
	version="$1"
	platform="$(get_platform)"
	architecture="$(get_system_architecture)"
	extension="$(get_file_extension "$platform")"
	filename="$2"

	url="$GH_REPO/releases/download/v${version}/migrate.${platform}-${architecture}.${extension}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH/$tool_cmd" "$install_path"
		if [ -f "$install_path/$tool_cmd" ]; then
			echo "* Installed $TOOL_NAME $version to $install_path"
		else
			fail "Could not install $TOOL_NAME $version to $install_path"
		fi
		chmod +x "$install_path/$tool_cmd"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
