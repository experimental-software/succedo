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
snap install --devmode ./succedo_0.2.0_amd64.snap
```

### MacOS

```
flutter build macos --no-tree-shake-icons
find . -name "*.app"
rm -rf /Applications/succedo_desktop.app
mv ./build/macos/Build/Products/Release/succedo_desktop.app /Applications/succedo_desktop.app

ls -la ./Library/Containers/com.example.succedoDesktop/Data/
```


#### Run with console output

```
/Applications/succedo_desktop.app/Contents/MacOS/succedo_desktop
```


## References

- https://snapcraft.io/docs/gtk3-applications
- https://flutter.dev/desktop
