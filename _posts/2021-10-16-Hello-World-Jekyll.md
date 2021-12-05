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

I designed a favicon in [Krita](https://krita.org/en/), an free and open source painting program. Then followed a blog article by a guy called Paul Cochrane, you can view that at https://ptc-it.de/add-favicon-to-mm-jekyll-site/ , the article is faily detailed and will be useful if you are new, or you can follow how I did it for tufte-jekyll.
Get the images you want to use, put it in the ```/assets/img/``` folder. There are multiple favicon generator sites you could use to make a favicon or use an image to generate one. After placing the favicon in the img direcory open up ```/_includes/head.html``` and in that file put this line in 
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
module Jekyll
  class RenderFullWidthTag < Liquid::Tag
  require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      "<div><img class='fullwidth' src='#{@text[0]}'/></div> " +
      "<p><span class='marginnote'>#{@text[1]}</span></p>"
    end
  end
end

Liquid::Template.register_tag('fullwidth', Jekyll::RenderFullWidthTag)
   ```
Open the ```css/tufte.scss``` file and put in these lines for to style the author tag as it is in this site. You can modify the styles are you want but these are the ones I used.
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

So that's about it, there is a lot of work to do on this site it's very scuffed at the moment, but I might make it a repo, if I do significant changes to the theme. If I do make it a repo I'll link it here! Now to reap what I've sown and close this off with the author tag I created :)
{% postauthor 'Jason Carvalho' %}
