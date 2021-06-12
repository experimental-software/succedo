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

Also see https://experimental-software.atlassian.net/wiki/spaces/~958839839/blog/2020/12/30/3080591/LXD+Reset+configuration

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

## References

- https://snapcraft.io/docs/gtk3-applications
- https://flutter.dev/desktop


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

MIT
