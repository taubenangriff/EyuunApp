# eyuun ecs demo 

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
### Load 
- entities are loaded from the asset file, however instead of real data being present, it just loads the right empty components. 
- loading of dynamic data is using with the applyValues method of components, however this is only implemented at component level with no actual dataloader being present.
### Save 
- we can save the dynamic data of the character. There is the AssetSerializer for this which works with any component, and on a component level using the persist method.

### Next steps
- I guess instead of all the manual json export code, it'd be advisable to use https://pub.dev/documentation/dart_mappable as a base to map static and dynamic data and then just flat out export the thing.

## Accessing things 
- create entities and manipulate their component structure with the worldManager
- access the static asset library using the assetLoader 
- access the text library using the TextRepository

## 
