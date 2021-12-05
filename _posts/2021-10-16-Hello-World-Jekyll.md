---
layout: post
title:  "Hello World - Jekyll"
date:   2021-10-16 09:46:04
categories: jekyll open-sourcers-chronicle
---

{% newthought 'Hello World!' %} This is the first post in this website and my first time working with the open source static site generator [jekyll](https://jekyllrb.com/). Jekyll is written in [Ruby](https://www.ruby-lang.org/en/), which I haven't worked with before either so starting with hello world is appropriate. <!--more--> I'll go through the steps it took to get this page up and running.

## Installing the prerequisites

First I had to install Jekyll the process was relatively pain free. I run Arch Linux on my system so I had a look at the ArchWiki{% sidenote 1 'The [ArchWiki](https://wiki.archlinux.org/) is where you can find documentation on Arch Linux, anyone can add and modify the documentation.' %} and conviniently found a page on Jekyll. It gave me the [install instructions](https://wiki.archlinux.org/title/Jekyll#Installation) necessary. I had to install the ruby package add ruby to $PATH and then run a couple of commands to install Jekyll. The commands I had to run were: 
```shell
$ gem update
$ gem install jekyll
$ gem install bundler
# run in the directory with the jekyll site you config later
$ bundle update
```
## Choosing and setting-up a Jekyll theme

There a multitude of sites to choose your Jekyll theme from, some paid but also a lot of free open source onces. The one I chose of this site is [tufte-jekyll](https://github.com/clayh53/tufte-jekyll). I did some modifications to it, which we will deal with later. For now just clone the repo and navigate to the directory. Now you can run 
```shell
$ bundle update
```
Ruby 3.0 does not come with webrick so you need to use bundle to get it, run 
```shell 
$ bundle add webrick
```
After that you can run these two commands to start up and view your page:
```shell
jekyll build
jekyll serve -w
```
Then point to your broswer to the address specified as "Server address:". If everything went fine you will now see your site there.

## Making a new post and customizing things

Posts are in the ```/_posts/``` directory, in the tufte-jekyll theme I used there were example posts, I used that as a template for this one. In the _config.yml file you can set things like the name of the site and the name of the author. Again speaking for tufte-jekyll there was a file ```/_data/social.yml``` that you use to point the urls to your socials.

### Adding a Favicon.

I designed a favicon in [Krita](https://krita.org/en/), an free and open source digital art program; then followed a blog article by Paul Cochrane [https://ptc-it.de/add-favicon-to-mm-jekyll-site/](https://ptc-it.de/add-favicon-to-mm-jekyll-site/)[Archived](http://web.archive.org/web/20210614083222/https://ptc-it.de/add-favicon-to-mm-jekyll-site/), that article is more detailed and shows how to handle the website icon for a multitude of different browsers.
Get the images you want to use, put it in the ```/assets/img/``` folder. There are multiple favicon generator sites that allow to make a favicon from scratch or use an image to generate one. After placing the favicon in the img direcory open up ```/_includes/head.html``` and insert this line anywhere under the ```<head>``` tag (I chose line 7).
```html
<link rel="icon" type="image/png" sizes="32x32" href="{{site.baseurl}}/assets/img/favicon-32x32.png">
```
I put this in after line 7, you can put it anywhere under the ```<head>``` tag.

### Making a plugin for post author

I also wanted an author to be present in every article for that I made a custom plugin that reads a tag. When I type 
```md
{% postauthor 'Author name' %}
```
in the post.md file it will appear as 
{% postauthor 'Author name' %}
to acheive this I needed to make a plugin and edits to the css file, I did this all on tufte-jekyll as I have no other experience with jekyll I don't know how it will transfer to other themes ect.
To make the plugin make a file called ```postauthor.rb``` in the ```/_plugins``` directory. Then add these lines I've added comments to make it easy to digest.
``` ruby
## Liquid tag 'postauthor' used to add an block to credit the author
## in the main text area of the layout
## Usage {% postauthor 'Author Name' %}

module Jekyll
  class RenderPostAuthorTag < Liquid::Tag

require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
        "<div class='post-author'>#{@text[0]}</div>"
    end
  end
end

Liquid::Template.register_tag('postauthor', Jekyll::RenderPostAuthorTag )
   ```
Open the ```css/tufte.scss``` file and add these lines to style the author tag. You can modify the styles according to your needs.
``` scss
div.post-author{
    width: 80%;
    padding-left: 2.5%;
    padding-right: 2.5%;
    padding-top: 0;
    text-align: right;
    margin-right: -60%;
    font-variant: small-caps;
    font-size: 1.2em;
    letter-spacing: 0.05rem;
    font-style: italic;
}
```

## Conclusion

That's it, there is a lot of work to do on this site, it's very scuffed at the moment. If I do make it a repository with the sites code I'll link it here![repo](https://github.com/JasonCarvalho-tech/open-sourcerers-guild) Now to reap what I've sown and close this post off with the author tag I created :)
{% postauthor 'Jason Carvalho' %}
