# Github-fetcher

Do `pastebin get u1CttBFF gitfetch` to get it.
A fetcher for getting files from github.

to make your own github page make sure that there is a manifest.lua that inludes

1. Name (string),
2. Forced downlod directory (boolean),
3. Forced download directory directory (string)

e.g.
```
return {
  {"NAME_OF_FILE.txt",false},
  {"NAME_OF_FILE2.txt",true,"test_folder/what"}
}
```

make sure it has the name of the file to be downloaded in a list.
