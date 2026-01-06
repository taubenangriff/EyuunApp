# eyuun ecs demo 

## Development 

- clone the repo 
- run `dart run build_runner build` to rebuild all the mapping classes that are used for data IO.
- build 
- to view documentation, use:

```Shell
dart pub global activate dhttpd
dart pub global run dhttpd --path doc/api
```

- then go to http://localhost:8080 

> Note that the eyuuncore and editor reside in ./eyuuncore and ./editor respectively, the build_runners for those projects must be run seperatly.

## Assets 
### Asset Structure
- Assets have two kinds of data, static and dynamic
- dynamic data is created at runtime, like the concrete amount of hitpoints a character has at the moment
- static data is fixed at all times, like the concrete amount of max hitpoints a character has by default.
- assets can be instanced as an entity.
- assets have a typeId unique to an asset
- entites have an objectId unique to that entity instance.

### Asset Library

- in data/base/asset/assets.json, a library of assets is defined.
- static asset data is defined in the asset library

### Editor 
- the asset file can include other asset files.
- the asset library is generated using the editor from the project files. 
- The project files for the assets are in ./editor/assetdata, one file, one asset.

## Accessing things

### get_it 
- I used get_it for service registry and location. 
- register Services in `lib/core/registerServices.dart` 
- access a service wherever you need it with `locator<YourService>()`

### Services
- WorldManager: create entities and manipulate their component structure
- GameObjectService: Access static asset data, get asset instances via their objectId and create new Asset Instances.
- LoadDataService: Service that reloads asset data.
- TextService: access the text library
- CharacterService: access and change the current character 

## Localization 
- Even though not a primary requirement, the backbone of the app already supports loading different text files.
- A static key <> text dictionary is loaded from the text file  

# Licensing

dice icons from https://game-icons.net/tags/dice.html, Delapouite and Skoll under CC 3.0