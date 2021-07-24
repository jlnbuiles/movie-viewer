# movie-viewer
a simple app that demonstrates object mapping, http requests, error handling and unit tests.

## Project Structure
#### ViewControllers
- MoviesTVC - list of movies
- MovieDetailsVC - details of the selected movie

#### Networking
- MovieDBHTTPClient - Responsible for interacting with the MovieDB web services

#### Repositories
- MovieRepository - An abstraction layer that allows the app to use a local custom caching system when certain rules are met.

#### Persistence
- MovieCacheManager - A simple yet effective custom-implemented caching system for movies.

#### Models
- BaseEntity - a base entity
- Movie - Represents a movie

#### Tests
- MovieTests - Unit tests for the movie model

## Questions
1. En qué consiste el principio de responsabilidad única? Cuál es su propósito?
Idealmente, cada clase debería de tener una responsabilidad definida y clara. En el momento en el que esa responsabilidad comience a sentirse muy amplia, debe cuestionarse si tiene sentido restringir más la clase o extender parte de lo que hace a otra(s) clases/entidades

2. Qué características tiene, según su opinión, un “buen” código o código limpio
Son muchas las características de escribir buen código, incluso hace unos años escribí un [artículo sobre esto en Medium](https://medium.com/developers-writing/writing-code-poetry-readability-1f272452519). Pero de una manera resumida:
- Cada objeto debe tener una responsabilidad clara
- Tu código debería de ser tan legible y fácil de entender que casi ni requiera documentación (self-documenting code)
- Usa nombres de variables que sean singificativos
- Escribe el código que te gustaría leer
- El buen código se puede testiar facilmente
- El buen código debe seguir estándares de lenguaje, arquitectura y del proyecto. Deben haber estándares.
