+++
title = "How was this site built"
date = "2024-07-29"
+++

These days as a content creator there are so many options for having a website presence.
I wanted to create one for as little as possible, to show others that one only needs time and motivation to create a blog of their
own.

# Zola - Static Site Generator

This blog was created using the [zola](https://www.getzola.org) static site generator. It makes the creation of blog content as simple as some mark
down files in a folder. You might need to learn a little bit of command line usage to use it, but it is otherwise very 
simple to use. Give it a shot!

For the theme, I am using the simple yet appealing [Tabi theme](https://www.getzola.org/themes/tabi/), and I thank its creator for making such a clean theme.

For the particularly curious, it happens to be written in rust, which appealed to me because it is a programming language
I am currently learning. On that, syntax highlighting is supported too... check it out!

```rust
fn rust_is_fun() -> Result<(&str)> {
    let rust = "awesome";
    Ok(rust)
}
```

# Hosting

I am hosting this on an ['App Platform' instance via Digital Ocean](https://www.digitalocean.com/pricing/app-platform), which is perfect for static site content because you 
can read from github or gitlab, and host up to three sites for free, with custom website domain name. That said there are
a bunch of other hosting providers that can host a static site for you, like github pages, for example.

# Custom Domain Names & DNS Management
This is an important piece for a website, and you have many options here too, but for this I went with namecheap for its 
low cost and ease of use.

Hope this helps answer the question for those curious.