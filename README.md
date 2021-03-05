# personal website

## Log

### Update 05.03.2020  

Decided to rewrite the static generating backend from a bunch of glued together bash scripts.  

Main goals are (a) to get rid of the pandoc dependency (because as of writing I can't get it compiled for arm64 macos) and (b) create a more coherent structure.  

**TODO List** for the rewrite:  

- [ ] make use of templating  
- [ ] write articles in markdown  
- [ ] ability to expand on markdown, e.g. expanded md-syntax for stylized checkboxes  
- [ ] easy to setup on any system  
- [ ] rewrite CSS or simplify/refactor old CSS  
- [ ] create a better "about me" page  
- [ ] keep it lightweight (previously, index was ~100kb and 60kb gzipped, loaded unter 500ms from github servers)
