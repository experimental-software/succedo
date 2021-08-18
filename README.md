# Succedo

Succedo is a simple desktop app which helps to work of tasks successively.

## Dependencies

In order to build this project, you need to have [Flutter](https://www.flutter.dev) installed.

## Build

### Ubuntu

#### Compile snap

```
snapcraft --use-lxd
```

**References**

- https://flutter.dev/docs/deployment/linux
- https://discuss.linuxcontainers.org/t/how-to-get-the-full-configuration-to-use-it-with-lxd-init-preseed/3333/4

#### Install snap

```
snap install --devmode ./succedo_0.2.1_amd64.snap
```

### MacOS

```
flutter build macos --no-tree-shake-icons
find . -name "*.app"
rm -rf /Applications/succedo.app
cp -r ./build/macos/Build/Products/Release/succedo.app /Applications/succedo.app

# ls -la ./Library/Containers/com.example.succedoDesktop/Data/
```

#### Run with console output

```
/Applications/succedo.app/Contents/MacOS/succedo
```

#### Run in background

```
nohup /Applications/succedo.app/Contents/MacOS/succedo > /tmp/succedo.log 2>&1 &
```

#### Run in background with specific project

```
PROJECT=~/doc/WIP/example.xml
nohup /Applications/succedo.app/Contents/MacOS/succedo $PROJECT > /tmp/succedo.log 2>&1 &
```

## References

- https://snapcraft.io/docs/gtk3-applications
- https://flutter.dev/desktop

## Development

### Design principles

> Clean code always looks like it was written by someone who cares. There is nothing obvious you can do to make it better. - [Michael Feathers](https://cvuorinen.net/2014/04/what-is-clean-code-and-why-should-you-care/)

## Alternatives

If Succedo is not what you need, then you might have a look at those task and note management tools:

- https://todoist.com
- https://www.rememberthemilk.com
- https://trello.com
- https://www.taskcoach.org
- https://culturedcode.com/things
- https://to-do.microsoft.com/tasks
- https://orgmode.org
- https://taskwarrior.org

## License

[MIT](LICENSE)
