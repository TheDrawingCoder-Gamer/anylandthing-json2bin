# Anyland Thing to GLTF

This project converts Anyland Things to GLTF. 
- Shapes are almost fully working except for rotation.
- Materials are (mostly) working. 
Note: This project used to be Thing to OBJ but OBJ files are simply not good enough, so I reverse engineered (read the documentation) of GLTF which supports PBR materials (which is the main reason I switched.)

This project also used to double as a Thing Json to BIN file but let's be honest that's pretty useless.

Current problems
- Damn Rotations :sob: Anylands rotation is... interesting to say the least. As of now, rotation is read as "Don't invert x, but invert y and z" and then it's converted to a quaternion with order of ZXY (which afaik is what unity uses). 
- Materials are not fully fleshed out. The only fully working materials I know are default (obviously) and unshaded because my test json is almost all unshaded. 
- Images; Currently any texture that is not in RGBA mode (which is basically all of them) simply doesn't work. This also messes up the base color. 

Pictures: 

<img src="https://github.com/TheDrawingCoder-Gamer/anylandthing-json2bin/blob/main/gh/example_model_al.jpg" width=50% height = 50%/>
