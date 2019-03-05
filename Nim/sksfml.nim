import csfml, strutils

#############################################################
# Just sort-of an interface to nim-csfml's functions, to
# have more clarity in the code, by prefixing functions
# with sf_, to resemble C++'s 'sf::' namespace thingy,
# and pySFML's 'sf.' module thingy.
#
# Possibly also prevents naming conflicts with other libs.
#
#                    WIP - skaruts
#############################################################

# interface for graphics
proc sf_RenderWindow*(mode: VideoMode, title: string, style: BitMaskU32 = WindowStyle.Default,
                     settings = contextSettings()): RenderWindow =
    new_RenderWindow( mode, title, style, settings )

# interface for vec2 overloads
proc sf_Vector2*(x, y: cint): Vector2i      = Vector2i(x: x, y: y)
proc sf_Vector2*(x, y: int):  Vector2i      = vec2(cint(x), cint(y))
proc sf_Vector2*(x, y: cfloat): Vector2f    = Vector2f(x: x, y: y)
proc sf_Vector2*(x, y: float): Vector2f     = vec2(cfloat(x), cfloat(y))
converter sf_Vector2*(a: Vector2i):Vector2f = vec2(cfloat(a.x), cfloat(a.y)) # todo: wtf is a converter??

# interface for vec3 overloads
proc sf_Vector3*(x, y, z: cfloat): Vector3f = Vector3f(x: x, y: y, z: z)
proc sf_Vector3*(x, y, z: float): Vector3f  = vec3(cfloat(x), cfloat(y), cfloat(z))

# interface for objects
proc sf_Texture*(filename:string): Texture  = new_Texture(filename)
# todo: sf_Sprite, sf_Image, etc

# interface for other stuff
proc sf_Vertex*(position = vec2(0.0, 0.0), color = White, texCoords = vec2(0.0, 0.0)):Vertex =
    vertex(position, color, texCoords)

proc sf_RenderStates*(blendMode = BlendAlpha, transform = Identity,
                   texture: Texture = nil, shader: Shader = nil): RenderStates =
    renderStates(blendMode=blendMode, transform=transform, texture=texture, shader=shader)

proc sf_VertexArray*(primitiveType: PrimitiveType, vertexCount = 0): VertexArray =
    newVertexArray(primitiveType, vertexCount)

# interface for 'color' overloads
proc sf_Color8(c:uint8) : Color;        # these are private
proc sf_Color16(c:uint16) : Color;      # used internally by
proc sf_Color16a(c:uint16) : Color;     # sf_Color(hex_string)
proc sf_Color32(c:uint32) : Color;      # sf_Color(int,int,int,int)
proc sf_Color32a(c:uint32) : Color;     # sf_Color(float,float,float,float)

proc `$`(c:Color):string = # just because I personally prefer having the 'Color(...)' prefix
    "Color(r:" & $c.r & ", g:" & $c.g & ", b:" & $c.b & ", a:" & $c.a & ")"

proc toBin*(c:Color, bits:int):string =
    # debug helper to see binary representation of a color
    $toBin(int(c.r), bits) & " " & $toBin(int(c.g), bits) & " " & $toBin(int(c.b), bits) & " " & $toBin(int(c.a), bits)

# proc test_print(text:string, c:Color, bits:int=8) =
#     echo ">>> DEBUG - ", text, "  |  ", toBin(c, bits), "  |  ", $c

# public
proc sf_Color*(r, g, b:float, a:float = 1.0 ) : Color =
    # floats in range 0 - 1  |  alpha is optional
    result.r = uint8( clamp( int(r*255), 0, 255 ) )
    result.g = uint8( clamp( int(g*255), 0, 255 ) )
    result.b = uint8( clamp( int(b*255), 0, 255 ) )
    result.a = uint8( clamp( int(a*255), 0, 255 ) )
    # test_print("sf_Color*(r, g, b, a: float): ", result, 8)

proc sf_Color*(r, g, b:int, a:int = 255 ) : Color =
    # ints in range 0 - 255  |  alpha is optional
    result.r = uint8( clamp( r, 0, 255 ) )
    result.g = uint8( clamp( g, 0, 255 ) )
    result.b = uint8( clamp( b, 0, 255 ) )
    result.a = uint8( clamp( a, 0, 255 ) )
    # test_print("sf_Color*(r, g, b, a: int): ", result, 8)

proc sf_Color*(c:string): Color =
    # int in the form of a hex string as
    # "rrggbbaa" : uint32
    # "rrggbb"   : uint32
    # "rgba"     : uint16
    # "rgb"      : uint16
    # "F"        : uint8 (4 bit color : 0 to F)
    let invalid = AllChars - HexDigits
    if c.find(invalid) == -1 and len(c) in [1,3,4,6,8]:
        case len(c)
            of 8: result = sf_Color32a(uint32(parseHexInt(c)))
            of 6: result = sf_Color32( uint32(parseHexInt(c)))
            of 4: result = sf_Color16a(uint16(parseHexInt(c)))
            of 3: result = sf_Color16( uint16(parseHexInt(c)))
            of 1: result = sf_Color8(   uint8(parseHexInt(c)))
            else: discard
    else:
        # echo "ERROR - invalid color: ", c
        # a single float should direct it to the floats overload (untested)
        result = sf_Color(1, 1, 1, 1.0)


# private
proc sf_Color32a(c:uint32) : Color =
    result.r = uint8((c shr 24) and 0xff)
    result.g = uint8((c shr 16) and 0xff)
    result.b = uint8((c shr  8) and 0xff)
    result.a = uint8((c shr  0) and 0xff)
    # test_print("sf_Color32a(uint32): ", result, 8)

proc sf_Color32(c:uint32) : Color =
    result.r = uint8((c shr 16) and 0xff)
    result.g = uint8((c shr  8) and 0xff)
    result.b = uint8((c shr  0) and 0xff)
    result.a = 255'u8
    # test_print("sf_Color32(uint32): ", result, 8)

proc sf_Color16a(c:uint16) : Color =
    result.r = uint8(((c shr 12) and 0xf)*255 div 15 )
    result.g = uint8(((c shr  8) and 0xf)*255 div 15 )
    result.b = uint8(((c shr  4) and 0xf)*255 div 15 )
    result.a = uint8(((c shr  0) and 0xf)*255 div 15 )
    # test_print("sf_Color16a(uint16): ", result, 4)

proc sf_Color16(c:uint16) : Color =
    result.r = uint8(((c shr 8) and 0xf)*255 div 15 )
    result.g = uint8(((c shr 4) and 0xf)*255 div 15 )
    result.b = uint8(((c shr 0) and 0xf)*255 div 15 )
    result.a = 255'u8
    # test_print("sf_Color16(uint16): ", result, 4)

proc sf_Color8(c:uint8) : Color =
    # untested: no clue if the colors look good, but the numbers seem ok
    # should be nearly the same 16 colors native to the windows console
    result.r = uint8( (((c shr 2) and 0x1)*191) + (((c shr 3) and 0x1)*64) )
    result.g = uint8( (((c shr 1) and 0x1)*191) + (((c shr 3) and 0x1)*64) )
    result.b = uint8( (((c shr 0) and 0x1)*191) + (((c shr 3) and 0x1)*64) )
    result.a = 255'u8
    # test_print("sf_Color8(uint8): ", result, 1)



# todo: rects
