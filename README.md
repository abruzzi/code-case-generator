### Introduction

```sh
bundle install
```

- Edit `cases/tree.json` to define your cases
- Then run the following command

```sh
ruby case_generate.rb
```

To compile the `java` code in a deep folder structure, you can run:

```sh
find p1 -name "*.java" > source
javac @source  
```
