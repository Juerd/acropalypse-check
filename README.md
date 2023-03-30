Example use:

```sh
find images -type f -iname '*.png' -exec perl ~/Downloads/acropalypse-check.pl {} + | tee -a acropalypse.list
```

This will scan all files with .png or .PNG extensions in the `images` directory and append the paths of suspect files to a text file called `acropalypse.list`. These can then be fixed by running them through a PNG repair tool, like `optipng -fix`:

```sh
xargs -d '\n' -a acropalypse.list optipng -fix
```

> NOTE: This example will not correctly handle filenames that contain a newline (`\n`) character. You could change `\n` to `\0` in the Perl code (line 27) and change `-d '\n'` to `-0` in the `xargs` call if you need it to handle such filenames.


