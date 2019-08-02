# Image Fetcher App 🏞

### Features
The Image Fetcher app is a Ruby Script that does the following:
* Accepts a relative text file path when excecuted.
* Reads the file and expects each line to be an image URL. URLs must end in `.jpg`, `.gif`, or `.png`
* Uses the URLs to download the images and store in your local disk
* Downloaded images are stored in a `"/downloads"` folder in the root of this project
* Displays results of downloaded and error counts

## Sample File
See an example file [here](./sample_data.txt)

## Requirements
- Ruby
- Bundler

## Dependencies
- [Down](https://github.com/janko/down)


## Getting Started
* Clone the repo: `git clone https://github.com/raphaelakpan/image_fetcher.git`
* Change directory: `cd image_fetcher`
* Install dependencies: `bundle install`
* Run `ruby app.rb ./sample_data.txt`

## Sample output
![image](https://user-images.githubusercontent.com/23452546/62362294-8d883c80-b514-11e9-977c-93b27cbba31a.png)


## Tests
* Run `rspec`
