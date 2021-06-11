

# Succedo Desktop App

## Deployment

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
rm -rf /Applications/succedo_desktop.app
cp -r ./build/macos/Build/Products/Release/succedo_desktop.app /Applications/succedo_desktop.app

# ls -la ./Library/Containers/com.example.succedoDesktop/Data/
```


#### Run with console output

```
/Applications/succedo_desktop.app/Contents/MacOS/succedo_desktop
```


## References

- https://snapcraft.io/docs/gtk3-applications
- https://flutter.dev/desktop


# Succedo

Succedo is a simple TODO apps helps to work of tasks successively by maintaining a list of tasks and a task details screen.


## Alternatives

There are hundreds of other programs for task and note management.
If Succedo is not what you need or want, then you e.g. might want to have a look at those:

- https://todoist.com/app/
- https://to-do.microsoft.com/tasks/
- https://www.rememberthemilk.com/
- https://trello.com/en
- https://www.taskcoach.org/
- https://www.wunderlist.com/
- https://culturedcode.com/things/
- https://orgmode.org/
- https://taskwarrior.org/
