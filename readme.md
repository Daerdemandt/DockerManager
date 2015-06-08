## Docker repository manager
This one is to provide newest docker images that pass given tests.
Images will be available in two repos: 'deployable' and 'untested' with latter used for inner purposes only.
###Contents:
##### makefile:
Some images depend on other images. We'll manage dependencies with make. That is, single 'make' call should 
rebuild all images that need updating and also make sure every updated image passes its tests.
#####'dockerfiles' folder:
All the dockerfiles are stored here, hierarchically. Each image is defined by its dockerfile and proper name of 
its directory inside 'dockerfiles' directory, which will be treated as image's name (with '-' replacing all 
'/'s). No dockerfiles can be in the same directory. Directory with dockerfile can have subdirectories with other 
dockerfiles. They will be treated as dependents.
Proper names contain nothing but lowercase ascii characters, digits and underscore, directories that do not meet 
the criteria will be omitted so they can be used for tests, for example.

##TODO:
 * make at least one dockerfile that can be built manually
 * Build it using makefile
 * make dependent dockerfile (linux-python3), buildable manually
 * make it buildable by makefile
 * Check that all hierarchy meets requirements - every folder with proper name contains dockerfile.
 * Use proper .dockerignore
 * Many other stuff (tests)

