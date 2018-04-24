# arty
A tool to generate montage images for album art.

## Installation
```
gem install arty
```

## Usage
```
require 'arty'

a = Arty.new(["Daft Punk", "Kavinsky", "Empire of the Sun", "Justice"])
a.generate_montage()
```

## Output
Running the above code, produces an image like this at `./tmp/output.jpeg`
![output](https://user-images.githubusercontent.com/1433713/34084686-5a54b3e0-e34a-11e7-8e79-e663cdfb8aa5.jpeg)

## macOS High Sierra Installation Issues
macOS High Sierra ships with a newer version of `imagemagick` (a dependency of Arty). Running the `gem install arty` command will result in an error. 

To resolve, unlink imagemagick and relink the older version ((credit)[https://stackoverflow.com/a/43035892/1091502]):
```
brew unlink imagemagick
brew install imagemagick@6 && brew link imagemagick@6 --force
```