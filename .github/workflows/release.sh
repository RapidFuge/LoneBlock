name: Packwiz Modrinth Export and Release

on:
  push:
    tags:
      - 'v*.*.*' # Trigger on version tags, e.g., v1.0.0

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
    # Checkout the repository
    - name: Checkout repository
      uses: actions/checkout@v4

    # Set up Go
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: 1.21  # Adjust the Go version as needed

    # Install packwiz
    - name: Install Packwiz
      run: |
        go install github.com/packwiz/packwiz@latest
        export PATH=$PATH:$(go env GOPATH)/bin

    # Run packwiz modrinth export
    - name: Generate .mrpack file
      run: |
        packwiz modrinth export -o modpack.mrpack

    # Prepare other assets (example: README.md or custom files)
    - name: Prepare Assets
      run: |
        cp README.md release-notes.txt || echo "No README found"
        # Add any other asset preparation logic here

    # Upload multiple assets as release files
    - name: Create Release
      uses: actions/create-release@v1
      with:
        tag_name: ${{ github.ref_name }}
        release_name: ${{ github.ref_name }}
        body: "Automatically generated release for ${{ github.ref_name }}"
        draft: false
        prerelease: false
        generate_release_notes: true
        assets: |
          modpack.mrpack
          Create_LoneBlock_1.20.1.world.zip
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
