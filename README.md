# arty
A tool to generate montage images for album art.

## Usage
```
require './arty.rb'

a = Arty.new(["Daft Punk", "Kavinsky", "Empire of the Sun", "Justice"])
a.generate_montage()
```

## Output
Running the above code, produces an image like this at `./tmp/output.jpeg`
![output](https://user-images.githubusercontent.com/1433713/34084686-5a54b3e0-e34a-11e7-8e79-e663cdfb8aa5.jpeg)
