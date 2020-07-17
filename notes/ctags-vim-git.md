References
----------
[1] https://github.com/scottsbaldwin/effortless-ctags-with-git

Steps
-----
* Install Exuberant Ctags (`ctags` for vim) and not `etags` (for emacs).
* Setup global `.git_template`,
```bash
$ git config --global init.templatedir '~/.git_template'
$ mkdir -p ~/.git_template
```
* Create/copy scripts for ctags, post-{commit,merge,checkout,rewrite} inside `~/.git_template/hooks/`. Make sure the files are (or were made) executable using `chmod a+x ~/.git_template/hooks/*`.
* That's it for global settings, for new repos (`git init` and `git clone`), the hooks will work out-of-the-box. Still for manual trigger call `git ctags`.
* For existing repo, do `cp -r ~/.git_template/* .git/` and perform git operations. For manual trigger call `git ctags`.
