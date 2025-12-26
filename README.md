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


## Demo App 

- The app is a UX demo with a character page. 
- Paths are a demonstrator widget
- Attributes are fully wired to the backend. The button right now randomizes the characters dice for demo purposes. 
- The Health Button is also connected to the backend.
- Press the Download button to get a json export of all the dynamic data of the character.

## Assets 
### Asset Structure
- Assets have two kinds of data, static and dynamic
- dynamic data is created at runtime, like the concrete amount of hitpoints a character has at the moment
- static data is fixed at all times, like the concrete amount of max hitpoints a character has by default.
- assets can be instanced as an entity.
- assets have a typeId unique to an asset
- entites have an objectId unique to that entity instance.

### Asset Library

- in data/base/asset/assets.json, a library of static assets is defined.
- It's like the old flexapps repositories, but this is for all kinds of entities at once.
- assets only define their static data in here
- dynamic data is persisted "elsewhere"

## IO 
### dart_mappable 
- I used dart_mappable to easily create some mappable classes for the dynamic and static data parts. 
- Yes, this means code duplication of nearly all properties and some manual mapping again, but as flutter is lacking proper reflection, this is even one of the more concise ways to do it...

### Load 
- entities are loaded from the asset file, where the static asset data is defined.
- loading of dynamic data is using with the `loadDynamicData` method of components.
- although not implemented, loading of dynamic data will be going like this: 
```
for key in dynamic_data_map 
    if entity has component with key 
        load dynamic_data_map[key] into component
```
### Save 
- we can save the dynamic data of the character. There is the AssetSerializer for this which works with any component, and on a component level using the `saveDynamicData` method.

## Accessing things

### get_it 
- I used get_it for service registry and location. 
- register Services in `lib/core/registerServices.dart` 
- access a service wherever you need it with `locator<YourService>()`

### Services
- WorldManager: create entities and manipulate their component structure
- AssetLoader: access the static asset library and create entity instances
- TextService: access the text library
- CharacterService: access and change the current character 

## Localization 
- Even though not a primary requirement, the backbone of the app already supports loading different text files.
- A static key <> text dictionary is loaded from the text file  

# Licensing

dice icons from https://game-icons.net/tags/dice.html, Delapouite and Skoll under CC 3.0