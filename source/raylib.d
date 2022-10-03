module raylib;

import core.stdc.stdlib;
import core.stdc.stdarg;
import core.stdc.config;

extern (C) @nogc nothrow:

/// Raylib's palette
enum Colors
{
	LIGHTGRAY = Color(200, 200, 200, 255),
	GRAY = Color(130, 130, 130, 255),
	DARKGRAY = Color(80, 80, 80, 255),
	YELLOW = Color(253, 249, 0, 255),
	GOLD = Color(255, 203, 0, 255),
	ORANGE = Color(255, 161, 0, 255),
	PINK = Color(255, 109, 194, 255),
	RED = Color(230, 41, 55, 255),
	MAROON = Color(190, 33, 55, 255),
	GREEN = Color(0, 228, 48, 255),
	LIME = Color(0, 158, 47, 255),
	DARKGREEN = Color(0, 117, 44, 255),
	SKYBLUE = Color(102, 191, 255, 255),
	BLUE = Color(0, 121, 241, 255),
	DARKBLUE = Color(0, 82, 172, 255),
	PURPLE = Color(200, 122, 255, 255),
	VIOLET = Color(135, 60, 190, 255),
	DARKPURPLE = Color(112, 31, 126, 255),
	BEIGE = Color(211, 176, 131, 255),
	BROWN = Color(127, 106, 79, 255),
	DARKBROWN = Color(76, 63, 47, 255),
	WHITE = Color(255, 255, 255, 255),
	BLACK = Color(0, 0, 0, 255),
	BLANK = Color(0, 0, 0, 0),
	MAGENTA = Color(255,
		0, 255, 255),
	RAYWHITE = Color(245, 245, 245, 255),
}

//----------------------------------------------------------------------------------
// Structures Definition
//----------------------------------------------------------------------------------

/// Vector2, 2 components
struct Vector2
{
	float x; /// Vector x component
	float y; /// Vector y component
}

/// Vector3, 3 components
struct Vector3
{
	float x; /// Vector x component
	float y; /// Vector y component
	float z; /// Vector z component
}

/// Vector4, 4 components
struct Vector4
{
	float x; /// Vector x component
	float y; /// Vector y component
	float z; /// Vector z component
	float w; /// Vector w component
}

/// Quaternion, 4 components (Vector4 alias)
alias Quaternion = Vector4;

/// Matrix, 4x4 components, column major, OpenGL style, right handed
struct Matrix
{
	/// Matrix first row (4 components)
	float m0, m4, m8, m12;
	/// Matrix second row (4 components)
	float m1, m5, m9, m13;
	/// Matrix third row (4 components)
	float m2, m6, m10, m14;
	/// Matrix fourth row (4 components)
	float m3, m7, m11, m15;
}

/// Color, 4 components, R8G8B8A8 (32bit)
struct Color
{
	ubyte r; /// Color red value
	ubyte g; /// Color green value
	ubyte b; /// Color blue value
	ubyte a; /// Color alpha value
}

/// Rectangle, 4 components
struct Rectangle
{
	float x; /// Rectangle top-left corner position x
	float y; /// Rectangle top-left corner position y
	float width; /// Rectangle width
	float height; /// Rectangle height
}

/// Image, pixel data stored in CPU memory (RAM)
struct Image
{
	void* data; /// Image raw data
	int width; /// Image base width
	int height; /// Image base height
	int mipmaps; /// Mipmap levels, 1 by default
	int format; /// Data format (PixelFormat type)
}

/// Texture, tex data stored in GPU memory (VRAM)
struct Texture
{
	uint id; /// OpenGL texture id
	int width; /// Texture base width
	int height; /// Texture base height
	int mipmaps; /// Mipmap levels, 1 by default
	int format; /// Data format (PixelFormat type)
}

/// Texture2D, same as Texture
alias Texture2D = Texture;

/// TextureCubemap, same as Texture
alias TextureCubemap = Texture;

/// RenderTexture, fbo for texture rendering
struct RenderTexture
{
	uint id; /// OpenGL framebuffer object id
	Texture texture; /// Color buffer attachment texture
	Texture depth; /// Depth buffer attachment texture
}

/// RenderTexture2D, same as RenderTexture
alias RenderTexture2D = RenderTexture;

/// NPatchInfo, n-patch layout info
struct NPatchInfo
{
	Rectangle source; /// Texture source rectangle
	int left; /// Left border offset
	int top; /// Top border offset
	int right; /// Right border offset
	int bottom; /// Bottom border offset
	int layout; /// Layout of the n-patch: 3x3, 1x3 or 3x1
}

/// GlyphInfo, font characters glyphs info
struct GlyphInfo
{
	int value; /// Character value (Unicode)
	int offsetX; /// Character offset X when drawing
	int offsetY; /// Character offset Y when drawing
	int advanceX; /// Character advance position X
	Image image; /// Character image data
}

/// Font, font texture and GlyphInfo array data
struct Font
{
	int baseSize; /// Base size (default chars height)
	int glyphCount; /// Number of glyph characters
	int glyphPadding; /// Padding around the glyph characters
	Texture2D texture; /// Texture atlas containing the glyphs
	Rectangle* recs; /// Rectangles in texture for the glyphs
	GlyphInfo* glyphs; /// Glyphs info data
}

/// Camera, defines position/orientation in 3d space
struct Camera3D
{
	Vector3 position; /// Camera position
	Vector3 target; /// Camera target it looks-at
	Vector3 up; /// Camera up vector (rotation over its axis)
	float fovy; /// Camera field-of-view apperture in Y (degrees) in perspective, used as near plane width in orthographic
	int projection; /// Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
}

alias Camera = Camera3D; /// Camera type fallback, defaults to Camera3D

/// Camera2D, defines position/orientation in 2d space
struct Camera2D
{
	Vector2 offset; /// Camera offset (displacement from target)
	Vector2 target; /// Camera target (rotation and zoom origin)
	float rotation; /// Camera rotation in degrees
	float zoom; /// Camera zoom (scaling), should be 1.0f by default
}

/// Mesh, vertex data and vao/vbo
struct Mesh
{
	int vertexCount; /// Number of vertices stored in arrays
	int triangleCount; /// Number of triangles stored (indexed or not)

	/// Vertex attributes data
	float* vertices; /// Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	float* texcoords; /// Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	float* texcoords2; /// Vertex second texture coordinates (useful for lightmaps) (shader-location = 5)
	float* normals; /// Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
	float* tangents; /// Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
	ubyte* colors; /// Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	ushort* indices; /// Vertex indices (in case vertex data comes indexed)

	/// Animation vertex data
	float* animVertices; /// Animated vertex positions (after bones transformations)
	float* animNormals; /// Animated normals (after bones transformations)
	int* boneIds; /// Vertex bone ids, up to 4 bones influence by vertex (skinning)
	float* boneWeights; /// Vertex bone weight, up to 4 bones influence by vertex (skinning)

	/// OpenGL identifiers
	uint vaoId; /// OpenGL Vertex Array Object id
	uint* vboId; /// OpenGL Vertex Buffer Objects id (default vertex data)
}

/// Shader
struct Shader
{
	uint id; /// Shader program id
	int* locs; /// Shader locations array (RL_MAX_SHADER_LOCATIONS)
}

/// MaterialMap
struct MaterialMap
{
	Texture2D texture; /// Material map texture
	Color color; /// Material map color
	float value; /// Material map value
}

/// Material, includes shader and maps
struct Material
{
	Shader shader; /// Material shader
	MaterialMap* maps; /// Material maps array (MAX_MATERIAL_MAPS)
	float[4] params; /// Material generic parameters (if required)
}

/// Transform, vectex transformation data
struct Transform
{
	Vector3 translation; /// Translation
	Quaternion rotation; /// Rotation
	Vector3 scale; /// Scale
}

/// Bone, skeletal animation bone
struct BoneInfo
{
	char[32] name; /// Bone name
	int parent; /// Bone parent
}

/// Model, meshes, materials and animation data
struct Model
{
	Matrix transform; /// Local transform matrix

	int meshCount; /// Number of meshes
	int materialCount; /// Number of materials
	Mesh* meshes; /// Meshes array
	Material* materials; /// Materials array
	int* meshMaterial; /// Mesh material number

	/// Animation data
	int boneCount; /// Number of bones
	BoneInfo* bones; /// Bones information (skeleton)
	Transform* bindPose; /// Bones base transformation (pose)
}

/// ModelAnimation
struct ModelAnimation
{
	int boneCount; /// Number of bones
	int frameCount; /// Number of animation frames
	BoneInfo* bones; /// Bones information (skeleton)
	Transform** framePoses; /// Poses array by frame
}

/// Ray, ray for raycasting
struct Ray
{
	Vector3 position; /// Ray position (origin)
	Vector3 direction; /// Ray direction
}

/// RayCollision, ray hit information
struct RayCollision
{
	bool hit; /// Did the ray hit something?
	float distance; /// Distance to nearest hit
	Vector3 point; /// Point of nearest hit
	Vector3 normal; /// Surface normal of hit
}

/// BoundingBox
struct BoundingBox
{
	Vector3 min; /// Minimum vertex box-corner
	Vector3 max; /// Maximum vertex box-corner
}

/// Wave, audio wave data
struct Wave
{
	uint frameCount; /// Total number of frames (considering channels)
	uint sampleRate; /// Frequency (samples per second)
	uint sampleSize; /// Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	uint channels; /// Number of channels (1-mono, 2-stereo, ...)
	void* data; /// Buffer data pointer
}

private struct rAudioBuffer;

/// AudioStream, custom audio stream
struct AudioStream
{
	rAudioBuffer* buffer; /// Pointer to internal data used by the audio system

	uint sampleRate; /// Frequency (samples per second)
	uint sampleSize; /// Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	uint channels; /// Number of channels (1-mono, 2-stereo, ...)
}

/// Sound
struct Sound
{
	AudioStream stream; /// Audio stream
	uint frameCount; /// Total number of frames (considering channels)
}

/// Music, audio stream, anything longer than ~10 seconds should be streamed
struct Music
{
	AudioStream stream; /// Audio stream
	uint frameCount; /// Total number of frames (considering channels)
	bool looping; /// Music looping enable

	int ctxType; /// Type of music context (audio filetype)
	void* ctxData; /// Audio context data, depends on type
}

/// VrDeviceInfo, Head-Mounted-Display device parameters
struct VrDeviceInfo
{
	int hResolution; /// Horizontal resolution in pixels
	int vResolution; /// Vertical resolution in pixels
	float hScreenSize; /// Horizontal size in meters
	float vScreenSize; /// Vertical size in meters
	float vScreenCenter; /// Screen center in meters
	float eyeToScreenDistance; /// Distance between eye and display in meters
	float lensSeparationDistance; /// Lens separation distance in meters
	float interpupillaryDistance; /// IPD (distance between pupils) in meters
	float[4] lensDistortionValues; /// Lens distortion constant parameters
	float[4] chromaAbCorrection; /// Chromatic aberration correction parameters
}

/// VrStereoConfig, VR stereo rendering configuration for simulator
struct VrStereoConfig
{
	Matrix[2] projection; /// VR projection matrices (per eye)
	Matrix[2] viewOffset; /// VR view offset matrices (per eye)
	float[2] leftLensCenter; /// VR left lens center
	float[2] rightLensCenter; /// VR right lens center
	float[2] leftScreenCenter; /// VR left screen center
	float[2] rightScreenCenter; /// VR right screen center
	float[2] scale; /// VR distortion scale
	float[2] scaleIn; /// VR distortion scale in
}

/// File path list
struct FilePathList
{
	uint capacity; /// Filepaths max entries
	uint count; /// Filepaths entries count
	char** paths; /// Filepaths entries
}

//----------------------------------------------------------------------------------
// Enumerators Definition
//----------------------------------------------------------------------------------
/// System/Window config flags
/// NOTE: Every bit registers one state (use it with bit masks). By default all flags are set to 0
enum ConfigFlags
{
	FLAG_VSYNC_HINT = 0x00000040, /// Set to try enabling V-Sync on GPU
	FLAG_FULLSCREEN_MODE = 0x00000002, /// Set to run program in fullscreen
	FLAG_WINDOW_RESIZABLE = 0x00000004, /// Set to allow resizable window
	FLAG_WINDOW_UNDECORATED = 0x00000008, /// Set to disable window decoration (frame and buttons)
	FLAG_WINDOW_HIDDEN = 0x00000080, /// Set to hide window
	FLAG_WINDOW_MINIMIZED = 0x00000200, /// Set to minimize window (iconify)
	FLAG_WINDOW_MAXIMIZED = 0x00000400, /// Set to maximize window (expanded to monitor)
	FLAG_WINDOW_UNFOCUSED = 0x00000800, /// Set to window non focused
	FLAG_WINDOW_TOPMOST = 0x00001000, /// Set to window always on top
	FLAG_WINDOW_ALWAYS_RUN = 0x00000100, /// Set to allow windows running while minimized
	FLAG_WINDOW_TRANSPARENT = 0x00000010, /// Set to allow transparent framebuffer
	FLAG_WINDOW_HIGHDPI = 0x00002000, /// Set to support HighDPI
	FLAG_MSAA_4X_HINT = 0x00000020, /// Set to try enabling MSAA 4X
	FLAG_INTERLACED_HINT = 0x00010000 /// Set to try enabling interlaced video format (for V3D)
}

/// Trace log level
/// NOTE: Organized by priority level
enum TraceLogLevel
{
	LOG_ALL = 0, /// Display all logs
	LOG_TRACE, /// Trace logging, intended for internal use only
	LOG_DEBUG, /// Debug logging, used for internal debugging, it should be disabled on release builds
	LOG_INFO, /// Info logging, used for program execution info
	LOG_WARNING, /// Warning logging, used on recoverable failures
	LOG_ERROR, /// Error logging, used on unrecoverable failures
	LOG_FATAL, /// Fatal logging, used to abort program: exit(EXIT_FAILURE)
	LOG_NONE /// Disable logging
}

/// Keyboard keys (US keyboard layout)
/// NOTE: Use GetKeyPressed() to allow redefining required keys for alternative layouts
enum KeyboardKey
{
	KEY_NULL = 0, /// Key: NULL, used for no key pressed
	/// Alphanumeric keys
	KEY_APOSTROPHE = 39, /// Key: '
	KEY_COMMA = 44, /// Key: ,
	KEY_MINUS = 45, /// Key: -
	KEY_PERIOD = 46, /// Key: .
	KEY_SLASH = 47, /// Key: /
	KEY_ZERO = 48, /// Key: 0
	KEY_ONE = 49, /// Key: 1
	KEY_TWO = 50, /// Key: 2
	KEY_THREE = 51, /// Key: 3
	KEY_FOUR = 52, /// Key: 4
	KEY_FIVE = 53, /// Key: 5
	KEY_SIX = 54, /// Key: 6
	KEY_SEVEN = 55, /// Key: 7
	KEY_EIGHT = 56, /// Key: 8
	KEY_NINE = 57, /// Key: 9
	KEY_SEMICOLON = 59, /// Key: ;
	KEY_EQUAL = 61, /// Key: =
	KEY_A = 65, /// Key: A | a
	KEY_B = 66, /// Key: B | b
	KEY_C = 67, /// Key: C | c
	KEY_D = 68, /// Key: D | d
	KEY_E = 69, /// Key: E | e
	KEY_F = 70, /// Key: F | f
	KEY_G = 71, /// Key: G | g
	KEY_H = 72, /// Key: H | h
	KEY_I = 73, /// Key: I | i
	KEY_J = 74, /// Key: J | j
	KEY_K = 75, /// Key: K | k
	KEY_L = 76, /// Key: L | l
	KEY_M = 77, /// Key: M | m
	KEY_N = 78, /// Key: N | n
	KEY_O = 79, /// Key: O | o
	KEY_P = 80, /// Key: P | p
	KEY_Q = 81, /// Key: Q | q
	KEY_R = 82, /// Key: R | r
	KEY_S = 83, /// Key: S | s
	KEY_T = 84, /// Key: T | t
	KEY_U = 85, /// Key: U | u
	KEY_V = 86, /// Key: V | v
	KEY_W = 87, /// Key: W | w
	KEY_X = 88, /// Key: X | x
	KEY_Y = 89, /// Key: Y | y
	KEY_Z = 90, /// Key: Z | z
	KEY_LEFT_BRACKET = 91, /// Key: [
	KEY_BACKSLASH = 92, /// Key: '\'
	KEY_RIGHT_BRACKET = 93, /// Key: ]
	KEY_GRAVE = 96, /// Key: `
	/// Function keys
	KEY_SPACE = 32, /// Key: Space
	KEY_ESCAPE = 256, /// Key: Esc
	KEY_ENTER = 257, /// Key: Enter
	KEY_TAB = 258, /// Key: Tab
	KEY_BACKSPACE = 259, /// Key: Backspace
	KEY_INSERT = 260, /// Key: Ins
	KEY_DELETE = 261, /// Key: Del
	KEY_RIGHT = 262, /// Key: Cursor right
	KEY_LEFT = 263, /// Key: Cursor left
	KEY_DOWN = 264, /// Key: Cursor down
	KEY_UP = 265, /// Key: Cursor up
	KEY_PAGE_UP = 266, /// Key: Page up
	KEY_PAGE_DOWN = 267, /// Key: Page down
	KEY_HOME = 268, /// Key: Home
	KEY_END = 269, /// Key: End
	KEY_CAPS_LOCK = 280, /// Key: Caps lock
	KEY_SCROLL_LOCK = 281, /// Key: Scroll down
	KEY_NUM_LOCK = 282, /// Key: Num lock
	KEY_PRINT_SCREEN = 283, /// Key: Print screen
	KEY_PAUSE = 284, /// Key: Pause
	KEY_F1 = 290, /// Key: F1
	KEY_F2 = 291, /// Key: F2
	KEY_F3 = 292, /// Key: F3
	KEY_F4 = 293, /// Key: F4
	KEY_F5 = 294, /// Key: F5
	KEY_F6 = 295, /// Key: F6
	KEY_F7 = 296, /// Key: F7
	KEY_F8 = 297, /// Key: F8
	KEY_F9 = 298, /// Key: F9
	KEY_F10 = 299, /// Key: F10
	KEY_F11 = 300, /// Key: F11
	KEY_F12 = 301, /// Key: F12
	KEY_LEFT_SHIFT = 340, /// Key: Shift left
	KEY_LEFT_CONTROL = 341, /// Key: Control left
	KEY_LEFT_ALT = 342, /// Key: Alt left
	KEY_LEFT_SUPER = 343, /// Key: Super left
	KEY_RIGHT_SHIFT = 344, /// Key: Shift right
	KEY_RIGHT_CONTROL = 345, /// Key: Control right
	KEY_RIGHT_ALT = 346, /// Key: Alt right
	KEY_RIGHT_SUPER = 347, /// Key: Super right
	KEY_KB_MENU = 348, /// Key: KB menu
	/// Keypad keys
	KEY_KP_0 = 320, /// Key: Keypad 0
	KEY_KP_1 = 321, /// Key: Keypad 1
	KEY_KP_2 = 322, /// Key: Keypad 2
	KEY_KP_3 = 323, /// Key: Keypad 3
	KEY_KP_4 = 324, /// Key: Keypad 4
	KEY_KP_5 = 325, /// Key: Keypad 5
	KEY_KP_6 = 326, /// Key: Keypad 6
	KEY_KP_7 = 327, /// Key: Keypad 7
	KEY_KP_8 = 328, /// Key: Keypad 8
	KEY_KP_9 = 329, /// Key: Keypad 9
	KEY_KP_DECIMAL = 330, /// Key: Keypad .
	KEY_KP_DIVIDE = 331, /// Key: Keypad /
	KEY_KP_MULTIPLY = 332, /// Key: Keypad *
	KEY_KP_SUBTRACT = 333, /// Key: Keypad -
	KEY_KP_ADD = 334, /// Key: Keypad +
	KEY_KP_ENTER = 335, /// Key: Keypad Enter
	KEY_KP_EQUAL = 336, /// Key: Keypad =
	/// Android key buttons
	KEY_BACK = 4, /// Key: Android back button
	KEY_MENU = 82, /// Key: Android menu button
	KEY_VOLUME_UP = 24, /// Key: Android volume up button
	KEY_VOLUME_DOWN = 25 /// Key: Android volume down button
}

/// Mouse buttons
enum MouseButton
{
	MOUSE_BUTTON_LEFT = 0, /// Mouse button left
	MOUSE_BUTTON_RIGHT = 1, /// Mouse button right
	MOUSE_BUTTON_MIDDLE = 2, /// Mouse button middle (pressed wheel)
	MOUSE_BUTTON_SIDE = 3, /// Mouse button side (advanced mouse device)
	MOUSE_BUTTON_EXTRA = 4, /// Mouse button extra (advanced mouse device)
	MOUSE_BUTTON_FORWARD = 5, /// Mouse button fordward (advanced mouse device)
	MOUSE_BUTTON_BACK = 6, /// Mouse button back (advanced mouse device)
}

// Add backwards compatibility support for deprecated names
alias MOUSE_LEFT_BUTTON = MouseButton.MOUSE_BUTTON_LEFT;
alias MOUSE_RIGHT_BUTTON = MouseButton.MOUSE_BUTTON_RIGHT;
alias MOUSE_MIDDLE_BUTTON = MouseButton.MOUSE_BUTTON_MIDDLE;

/// Mouse cursor
enum MouseCursor
{
	MOUSE_CURSOR_DEFAULT = 0, /// Default pointer shape
	MOUSE_CURSOR_ARROW = 1, /// Arrow shape
	MOUSE_CURSOR_IBEAM = 2, /// Text writing cursor shape
	MOUSE_CURSOR_CROSSHAIR = 3, /// Cross shape
	MOUSE_CURSOR_POINTING_HAND = 4, /// Pointing hand cursor
	MOUSE_CURSOR_RESIZE_EW = 5, /// Horizontal resize/move arrow shape
	MOUSE_CURSOR_RESIZE_NS = 6, /// Vertical resize/move arrow shape
	MOUSE_CURSOR_RESIZE_NWSE = 7, /// Top-left to bottom-right diagonal resize/move arrow shape
	MOUSE_CURSOR_RESIZE_NESW = 8, /// The top-right to bottom-left diagonal resize/move arrow shape
	MOUSE_CURSOR_RESIZE_ALL = 9, /// The omni-directional resize/move cursor shape
	MOUSE_CURSOR_NOT_ALLOWED = 10 /// The operation-not-allowed shape
}

/// Gamepad buttons
enum GamepadButton
{
	GAMEPAD_BUTTON_UNKNOWN = 0, /// Unknown button, just for error checking
	GAMEPAD_BUTTON_LEFT_FACE_UP, /// Gamepad left DPAD up button
	GAMEPAD_BUTTON_LEFT_FACE_RIGHT, /// Gamepad left DPAD right button
	GAMEPAD_BUTTON_LEFT_FACE_DOWN, /// Gamepad left DPAD down button
	GAMEPAD_BUTTON_LEFT_FACE_LEFT, /// Gamepad left DPAD left button
	GAMEPAD_BUTTON_RIGHT_FACE_UP, /// Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
	GAMEPAD_BUTTON_RIGHT_FACE_RIGHT, /// Gamepad right button right (i.e. PS3: Square, Xbox: X)
	GAMEPAD_BUTTON_RIGHT_FACE_DOWN, /// Gamepad right button down (i.e. PS3: Cross, Xbox: A)
	GAMEPAD_BUTTON_RIGHT_FACE_LEFT, /// Gamepad right button left (i.e. PS3: Circle, Xbox: B)
	GAMEPAD_BUTTON_LEFT_TRIGGER_1, /// Gamepad top/back trigger left (first), it could be a trailing button
	GAMEPAD_BUTTON_LEFT_TRIGGER_2, /// Gamepad top/back trigger left (second), it could be a trailing button
	GAMEPAD_BUTTON_RIGHT_TRIGGER_1, /// Gamepad top/back trigger right (one), it could be a trailing button
	GAMEPAD_BUTTON_RIGHT_TRIGGER_2, /// Gamepad top/back trigger right (second), it could be a trailing button
	GAMEPAD_BUTTON_MIDDLE_LEFT, /// Gamepad center buttons, left one (i.e. PS3: Select)
	GAMEPAD_BUTTON_MIDDLE, /// Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
	GAMEPAD_BUTTON_MIDDLE_RIGHT, /// Gamepad center buttons, right one (i.e. PS3: Start)
	GAMEPAD_BUTTON_LEFT_THUMB, /// Gamepad joystick pressed button left
	GAMEPAD_BUTTON_RIGHT_THUMB /// Gamepad joystick pressed button right
}

/// Gamepad axis
enum GamepadAxis
{
	GAMEPAD_AXIS_LEFT_X = 0, /// Gamepad left stick X axis
	GAMEPAD_AXIS_LEFT_Y = 1, /// Gamepad left stick Y axis
	GAMEPAD_AXIS_RIGHT_X = 2, /// Gamepad right stick X axis
	GAMEPAD_AXIS_RIGHT_Y = 3, /// Gamepad right stick Y axis
	GAMEPAD_AXIS_LEFT_TRIGGER = 4, /// Gamepad back trigger left, pressure level: [1..-1]
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5 /// Gamepad back trigger right, pressure level: [1..-1]
}

/// Material map index
enum MaterialMapIndex
{
	MATERIAL_MAP_ALBEDO = 0, /// Albedo material (same as: MATERIAL_MAP_DIFFUSE)
	MATERIAL_MAP_METALNESS, /// Metalness material (same as: MATERIAL_MAP_SPECULAR)
	MATERIAL_MAP_NORMAL, /// Normal material
	MATERIAL_MAP_ROUGHNESS, /// Roughness material
	MATERIAL_MAP_OCCLUSION, /// Ambient occlusion material
	MATERIAL_MAP_EMISSION, /// Emission material
	MATERIAL_MAP_HEIGHT, /// Heightmap material
	MATERIAL_MAP_CUBEMAP, /// Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	MATERIAL_MAP_IRRADIANCE, /// Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	MATERIAL_MAP_PREFILTER, /// Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	MATERIAL_MAP_BRDF /// Brdf material
}

alias MATERIAL_MAP_DIFFUSE = MaterialMapIndex.MATERIAL_MAP_ALBEDO;
alias MATERIAL_MAP_SPECULAR = MaterialMapIndex.MATERIAL_MAP_METALNESS;

/// Shader location index
enum ShaderLocationIndex
{
	SHADER_LOC_VERTEX_POSITION = 0, /// Shader location: vertex attribute: position
	SHADER_LOC_VERTEX_TEXCOORD01, /// Shader location: vertex attribute: texcoord01
	SHADER_LOC_VERTEX_TEXCOORD02, /// Shader location: vertex attribute: texcoord02
	SHADER_LOC_VERTEX_NORMAL, /// Shader location: vertex attribute: normal
	SHADER_LOC_VERTEX_TANGENT, /// Shader location: vertex attribute: tangent
	SHADER_LOC_VERTEX_COLOR, /// Shader location: vertex attribute: color
	SHADER_LOC_MATRIX_MVP, /// Shader location: matrix uniform: model-view-projection
	SHADER_LOC_MATRIX_VIEW, /// Shader location: matrix uniform: view (camera transform)
	SHADER_LOC_MATRIX_PROJECTION, /// Shader location: matrix uniform: projection
	SHADER_LOC_MATRIX_MODEL, /// Shader location: matrix uniform: model (transform)
	SHADER_LOC_MATRIX_NORMAL, /// Shader location: matrix uniform: normal
	SHADER_LOC_VECTOR_VIEW, /// Shader location: vector uniform: view
	SHADER_LOC_COLOR_DIFFUSE, /// Shader location: vector uniform: diffuse color
	SHADER_LOC_COLOR_SPECULAR, /// Shader location: vector uniform: specular color
	SHADER_LOC_COLOR_AMBIENT, /// Shader location: vector uniform: ambient color
	SHADER_LOC_MAP_ALBEDO, /// Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
	SHADER_LOC_MAP_METALNESS, /// Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
	SHADER_LOC_MAP_NORMAL, /// Shader location: sampler2d texture: normal
	SHADER_LOC_MAP_ROUGHNESS, /// Shader location: sampler2d texture: roughness
	SHADER_LOC_MAP_OCCLUSION, /// Shader location: sampler2d texture: occlusion
	SHADER_LOC_MAP_EMISSION, /// Shader location: sampler2d texture: emission
	SHADER_LOC_MAP_HEIGHT, /// Shader location: sampler2d texture: height
	SHADER_LOC_MAP_CUBEMAP, /// Shader location: samplerCube texture: cubemap
	SHADER_LOC_MAP_IRRADIANCE, /// Shader location: samplerCube texture: irradiance
	SHADER_LOC_MAP_PREFILTER, /// Shader location: samplerCube texture: prefilter
	SHADER_LOC_MAP_BRDF /// Shader location: sampler2d texture: brdf
}

alias SHADER_LOC_MAP_DIFFUSE = ShaderLocationIndex.SHADER_LOC_MAP_ALBEDO;
alias SHADER_LOC_MAP_SPECULAR = ShaderLocationIndex.SHADER_LOC_MAP_METALNESS;

/// Shader uniform data type
enum ShaderUniformDataType
{
	SHADER_UNIFORM_FLOAT = 0, /// Shader uniform type: float
	SHADER_UNIFORM_VEC2, /// Shader uniform type: vec2 (2 float)
	SHADER_UNIFORM_VEC3, /// Shader uniform type: vec3 (3 float)
	SHADER_UNIFORM_VEC4, /// Shader uniform type: vec4 (4 float)
	SHADER_UNIFORM_INT, /// Shader uniform type: int
	SHADER_UNIFORM_IVEC2, /// Shader uniform type: ivec2 (2 int)
	SHADER_UNIFORM_IVEC3, /// Shader uniform type: ivec3 (3 int)
	SHADER_UNIFORM_IVEC4, /// Shader uniform type: ivec4 (4 int)
	SHADER_UNIFORM_SAMPLER2D /// Shader uniform type: sampler2d
}

/// Shader attribute data types
enum ShaderAttributeDataType
{
	SHADER_ATTRIB_FLOAT = 0, /// Shader attribute type: float
	SHADER_ATTRIB_VEC2, /// Shader attribute type: vec2 (2 float)
	SHADER_ATTRIB_VEC3, /// Shader attribute type: vec3 (3 float)
	SHADER_ATTRIB_VEC4 /// Shader attribute type: vec4 (4 float)
}

/// Pixel formats
/// NOTE: Support depends on OpenGL version and platform
enum PixelFormat
{
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1, /// 8 bit per pixel (no alpha)
	PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA, /// 8*2 bpp (2 channels)
	PIXELFORMAT_UNCOMPRESSED_R5G6B5, /// 16 bpp
	PIXELFORMAT_UNCOMPRESSED_R8G8B8, /// 24 bpp
	PIXELFORMAT_UNCOMPRESSED_R5G5B5A1, /// 16 bpp (1 bit alpha)
	PIXELFORMAT_UNCOMPRESSED_R4G4B4A4, /// 16 bpp (4 bit alpha)
	PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, /// 32 bpp
	PIXELFORMAT_UNCOMPRESSED_R32, /// 32 bpp (1 channel - float)
	PIXELFORMAT_UNCOMPRESSED_R32G32B32, /// 32*3 bpp (3 channels - float)
	PIXELFORMAT_UNCOMPRESSED_R32G32B32A32, /// 32*4 bpp (4 channels - float)
	PIXELFORMAT_COMPRESSED_DXT1_RGB, /// 4 bpp (no alpha)
	PIXELFORMAT_COMPRESSED_DXT1_RGBA, /// 4 bpp (1 bit alpha)
	PIXELFORMAT_COMPRESSED_DXT3_RGBA, /// 8 bpp
	PIXELFORMAT_COMPRESSED_DXT5_RGBA, /// 8 bpp
	PIXELFORMAT_COMPRESSED_ETC1_RGB, /// 4 bpp
	PIXELFORMAT_COMPRESSED_ETC2_RGB, /// 4 bpp
	PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA, /// 8 bpp
	PIXELFORMAT_COMPRESSED_PVRT_RGB, /// 4 bpp
	PIXELFORMAT_COMPRESSED_PVRT_RGBA, /// 4 bpp
	PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA, /// 8 bpp
	PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA /// 2 bpp
}

/// Texture parameters: filter mode
/// NOTE 1: Filtering considers mipmaps if available in the texture
/// NOTE 2: Filter is accordingly set for minification and magnification
enum TextureFilter
{
	TEXTURE_FILTER_POINT = 0, /// No filter, just pixel aproximation
	TEXTURE_FILTER_BILINEAR, /// Linear filtering
	TEXTURE_FILTER_TRILINEAR, /// Trilinear filtering (linear with mipmaps)
	TEXTURE_FILTER_ANISOTROPIC_4X, /// Anisotropic filtering 4x
	TEXTURE_FILTER_ANISOTROPIC_8X, /// Anisotropic filtering 8x
	TEXTURE_FILTER_ANISOTROPIC_16X, /// Anisotropic filtering 16x
}

/// Texture parameters: wrap mode
enum TextureWrap
{
	TEXTURE_WRAP_REPEAT = 0, /// Repeats texture in tiled mode
	TEXTURE_WRAP_CLAMP, /// Clamps texture to edge pixel in tiled mode
	TEXTURE_WRAP_MIRROR_REPEAT, /// Mirrors and repeats the texture in tiled mode
	TEXTURE_WRAP_MIRROR_CLAMP /// Mirrors and clamps to border the texture in tiled mode
}

/// Cubemap layouts
enum CubemapLayout
{
	CUBEMAP_LAYOUT_AUTO_DETECT = 0, /// Automatically detect layout type
	CUBEMAP_LAYOUT_LINE_VERTICAL, /// Layout is defined by a vertical line with faces
	CUBEMAP_LAYOUT_LINE_HORIZONTAL, /// Layout is defined by an horizontal line with faces
	CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR, /// Layout is defined by a 3x4 cross with cubemap faces
	CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE, /// Layout is defined by a 4x3 cross with cubemap faces
	CUBEMAP_LAYOUT_PANORAMA /// Layout is defined by a panorama image (equirectangular map)
}

/// Font type, defines generation method
enum FontType
{
	FONT_DEFAULT = 0, /// Default font generation, anti-aliased
	FONT_BITMAP, /// Bitmap font generation, no anti-aliasing
	FONT_SDF /// SDF font generation, requires external shader
}

/// Color blending modes (pre-defined)
enum BlendMode
{
	BLEND_ALPHA = 0, /// Blend textures considering alpha (default)
	BLEND_ADDITIVE, /// Blend textures adding colors
	BLEND_MULTIPLIED, /// Blend textures multiplying colors
	BLEND_ADD_COLORS, /// Blend textures adding colors (alternative)
	BLEND_SUBTRACT_COLORS, /// Blend textures subtracting colors (alternative)
	BLEND_CUSTOM /// Belnd textures using custom src/dst factors (use rlSetBlendMode())
}

/// Gesture
/// NOTE: It could be used as flags to enable only some gestures
enum Gesture
{
	GESTURE_NONE = 0, /// No gesture
	GESTURE_TAP = 1, /// Tap gesture
	GESTURE_DOUBLETAP = 2, /// Double tap gesture
	GESTURE_HOLD = 4, /// Hold gesture
	GESTURE_DRAG = 8, /// Drag gesture
	GESTURE_SWIPE_RIGHT = 16, /// Swipe right gesture
	GESTURE_SWIPE_LEFT = 32, /// Swipe left gesture
	GESTURE_SWIPE_UP = 64, /// Swipe up gesture
	GESTURE_SWIPE_DOWN = 128, /// Swipe down gesture
	GESTURE_PINCH_IN = 256, /// Pinch in gesture
	GESTURE_PINCH_OUT = 512 /// Pinch out gesture
}

/// Camera system modes
enum CameraMode
{
	CAMERA_CUSTOM = 0, /// Custom camera
	CAMERA_FREE, /// Free camera
	CAMERA_ORBITAL, /// Orbital camera
	CAMERA_FIRST_PERSON, /// First person camera
	CAMERA_THIRD_PERSON /// Third person camera
}

/// Camera projection
enum CameraProjection
{
	CAMERA_PERSPECTIVE = 0, /// Perspective projection
	CAMERA_ORTHOGRAPHIC /// Orthographic projection
}

/// N-patch layout
enum NPatchLayout
{
	NPATCH_NINE_PATCH = 0, /// Npatch layout: 3x3 tiles
	NPATCH_THREE_PATCH_VERTICAL, /// Npatch layout: 1x3 tiles
	NPATCH_THREE_PATCH_HORIZONTAL /// Npatch layout: 3x1 tiles
}

// Callbacks to hook some internal functions
// WARNING: This callbacks are intended for advance users

alias TraceLogCallback = void function(int logLevel, const(char*) text, va_list args); /// Logging: Redirect trace log messages
alias LoadFileDataCallback = ubyte function(const(char*) fileName, uint* bytesRead); /// FileIO: Load binary data
alias SaveFileDataCallback = bool function(const(char*) fileName, void* data, uint bytesToWrite); /// FileIO: Save binary data
alias LoadFileTextCallback = char function(const(char*) fileName); /// FileIO: Load text data
alias SaveFileTextCallback = bool function(const(char*) fileName, char* text); /// FileIO: Save text data

//------------------------------------------------------------------------------------
// Global Variables Definition
//------------------------------------------------------------------------------------
// It's lonely here...

//------------------------------------------------------------------------------------
// Window and Graphics Device Functions (Module: core)
//------------------------------------------------------------------------------------

/// Initialize window and OpenGL context
void InitWindow(int width, int height, const(char*) title);
/// Check if KEY_ESCAPE pressed or Close icon pressed
bool WindowShouldClose();
/// Close window and unload OpenGL context
void CloseWindow();
/// Check if window has been initialized successfully
bool IsWindowReady();
/// Check if window is currently fullscreen
bool IsWindowFullscreen();
/// Check if window is currently hidden (only PLATFORM_DESKTOP)
bool IsWindowHidden();
/// Check if window is currently minimized (only PLATFORM_DESKTOP)
bool IsWindowMinimized();
/// Check if window is currently maximized (only PLATFORM_DESKTOP)
bool IsWindowMaximized();
/// Check if window is currently focused (only PLATFORM_DESKTOP)
bool IsWindowFocused();
/// Check if window has been resized last frame
bool IsWindowResized();
/// Check if one specific window flag is enabled
bool IsWindowState(uint flag);
/// Set window configuration state using flags
void SetWindowState(uint flags);
/// Clear window configuration state flags
void ClearWindowState(uint flags);
/// Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
void ToggleFullscreen();
/// Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
void MaximizeWindow();
/// Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
void MinimizeWindow();
/// Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
void RestoreWindow();
/// Set icon for window (only PLATFORM_DESKTOP)
void SetWindowIcon(Image image);
/// Set title for window (only PLATFORM_DESKTOP)
void SetWindowTitle(const(char*) title);
/// Set window position on screen (only PLATFORM_DESKTOP)
void SetWindowPosition(int x, int y);
/// Set monitor for the current window (fullscreen mode)
void SetWindowMonitor(int monitor);
/// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
void SetWindowMinSize(int width, int height);
/// Set window dimensions
void SetWindowSize(int width, int height);
/// Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
void SetWindowOpacity(float opacity);
/// Get native window handle
void* GetWindowHandle();
/// Get current screen width
int GetScreenWidth();
/// Get current screen height
int GetScreenHeight();
/// Get number of connected monitors
int GetMonitorCount();
/// Get current connected monitor
int GetCurrentMonitor();
/// Get specified monitor position
Vector2 GetMonitorPosition(int monitor);
/// Get specified monitor width (max available by monitor)
int GetMonitorWidth(int monitor);
/// Get specified monitor height (max available by monitor)
int GetMonitorHeight(int monitor);
/// Get specified monitor physical width in millimetres
int GetMonitorPhysicalWidth(int monitor);
/// Get specified monitor physical height in millimetres
int GetMonitorPhysicalHeight(int monitor);
/// Get specified monitor refresh rate
int GetMonitorRefreshRate(int monitor);
/// Get window position XY on monitor
Vector2 GetWindowPosition();
/// Get window scale DPI factor
Vector2 GetWindowScaleDPI();
/// Get the human-readable, UTF-8 encoded name of the primary monitor
const(char*) GetMonitorName(int monitor);
/// Set clipboard text content
void SetClipboardText(const(char*) text);
/// Get clipboard text content
const(char*) GetClipboardText();

// Custom frame control functions
// NOTE: Those functions are intended for advance users that want full control over the frame processing
// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timming + PollInputEvents()
// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
/// Swap back buffer with front buffer (screen drawing)
void SwapScreenBuffer();
/// Register all input events
void PollInputEvents();
/// Wait for some milliseconds (halt program execution)
void WaitTime(float ms);

// Cursor-related functions
/// Shows cursor
void ShowCursor();
/// Hides cursor
void HideCursor();
/// Check if cursor is not visible
bool IsCursorHidden();
/// Enables cursor (unlock cursor)
void EnableCursor();
/// Disables cursor (lock cursor)
void DisableCursor();
/// Check if cursor is on the screen
bool IsCursorOnScreen();

// Drawing-related functions
/// Set background color (framebuffer clear color)
void ClearBackground(Color color);
/// Setup canvas (framebuffer) to start drawing
void BeginDrawing();
/// End canvas drawing and swap buffers (double buffering)
void EndDrawing();
/// Begin 2D mode with custom camera (2D)
void BeginMode2D(Camera2D camera);
/// Ends 2D mode with custom camera
void EndMode2D();
/// Begin 3D mode with custom camera (3D)
void BeginMode3D(Camera3D camera);
/// Ends 3D mode and returns to default 2D orthographic mode
void EndMode3D();
/// Begin drawing to render texture
void BeginTextureMode(RenderTexture2D target);
/// Ends drawing to render texture
void EndTextureMode();
/// Begin custom shader drawing
void BeginShaderMode(Shader shader);
/// End custom shader drawing (use default shader)
void EndShaderMode();
/// Begin blending mode (alpha, additive, multiplied, subtract, custom)
void BeginBlendMode(int mode);
/// End blending mode (reset to default: alpha blending)
void EndBlendMode();
/// Begin scissor mode (define screen area for following drawing)
void BeginScissorMode(int x, int y, int width, int height);
/// End scissor mode
void EndScissorMode();
/// Begin stereo rendering (requires VR simulator)
void BeginVrStereoMode(VrStereoConfig config);
/// End stereo rendering (requires VR simulator)
void EndVrStereoMode();

// VR stereo config functions for VR simulator
/// Load VR stereo config for VR simulator device parameters
VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);
/// Unload VR stereo config
void UnloadVrStereoConfig(VrStereoConfig config);

// Shader management functions
// NOTE: Shader functionality is not available on OpenGL 1.1
/// Load shader from files and bind default locations
Shader LoadShader(const(char*) vsFileName, const(char*) fsFileName);
/// Load shader from code strings and bind default locations
Shader LoadShaderFromMemory(const(char*) vsCode, const(char*) fsCode);
/// Get shader uniform location
int GetShaderLocation(Shader shader, const(char*) uniformName);
/// Get shader attribute location
int GetShaderLocationAttrib(Shader shader, const(char*) attribName);
/// Set shader uniform value
void SetShaderValue(Shader shader, int locIndex, const void* value, int uniformType);
/// Set shader uniform value vector
void SetShaderValueV(Shader shader, int locIndex, const void* value, int uniformType, int count);
/// Set shader uniform value (matrix 4x4)
void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);
/// Set shader uniform value for texture (sampler2d)
void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture);
/// Unload shader from GPU memory (VRAM)
void UnloadShader(Shader shader);

// Screen-space-related functions
/// Get a ray trace from mouse position
Ray GetMouseRay(Vector2 mousePosition, Camera camera);
/// Get camera transform matrix (view matrix)
Matrix GetCameraMatrix(Camera camera);
/// Get camera 2d transform matrix
Matrix GetCameraMatrix2D(Camera2D camera);
/// Get the screen space position for a 3d world space position
Vector2 GetWorldToScreen(Vector3 position, Camera camera);
/// Get size position for a 3d world space position
Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height);
/// Get the screen space position for a 2d camera world space position
Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera);
/// Get the world space position for a 2d camera screen space position
Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera);

// Timing-related functions
/// Set target FPS (maximum)
void SetTargetFPS(int fps);
/// Get current FPS
int GetFPS();
/// Get time in seconds for last frame drawn (delta time)
float GetFrameTime();
/// Get elapsed time in seconds since InitWindow()
double GetTime();

// Misc. functions
/// Get a random value between min and max (both included)
int GetRandomValue(int min, int max);
/// Set the seed for the random number generator
void SetRandomSeed(uint seed);
/// Takes a screenshot of current screen (filename extension defines format)
void TakeScreenshot(const(char*) fileName);
/// Setup init configuration flags (view FLAGS)
void SetConfigFlags(uint flags);
/// Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
void TraceLog(int logLevel, const(char*) text, ...);
/// Set the current threshold (minimum) log level
void SetTraceLogLevel(int logLevel);
/// Internal memory allocator
void* MemAlloc(int size);
/// Internal memory reallocator
void* MemRealloc(void* ptr, int size);
/// Internal memory free
void MemFree(void* ptr);

// Set custom callbacks
// WARNING: Callbacks setup is intended for advance users
/// Set custom trace log
void SetTraceLogCallback(TraceLogCallback callback);
/// Set custom file binary data loader
void SetLoadFileDataCallback(LoadFileDataCallback callback);
/// Set custom file binary data saver
void SetSaveFileDataCallback(SaveFileDataCallback callback);
/// Set custom file text data loader
void SetLoadFileTextCallback(LoadFileTextCallback callback);
/// Set custom file text data saver
void SetSaveFileTextCallback(SaveFileTextCallback callback);

// Files management functions
/// Load file data as byte array (read)
ubyte* LoadFileData(const(char*) fileName, uint* bytesRead);
/// Unload file data allocated by LoadFileData()
void UnloadFileData(ubyte* data);
/// Save data to file from byte array (write), returns true on success
bool SaveFileData(const(char*) fileName, void* data, uint bytesToWrite);
/// Load text data from file (read), returns a '\0' terminated string
char* LoadFileText(const(char*) fileName);
/// Unload file text data allocated by LoadFileText()
void UnloadFileText(char* text);
/// Save text data to file (write), string must be '\0' terminated, returns true on success
bool SaveFileText(const(char*) fileName, char* text);
/// Check if file exists
bool FileExists(const(char*) fileName);
/// Check if a directory path exists
bool DirectoryExists(const(char*) dirPath);
/// Check file extension (including point: .png, .wav)
bool IsFileExtension(const(char*) fileName, const(char*) ext);
/// Get pointer to extension for a filename string (includes dot: '.png')
const(char*) GetFileExtension(const(char*) fileName);
/// Get pointer to filename for a path string
const(char*) GetFileName(const(char*) filePath);
/// Get filename string without extension (uses static string)
const(char*) GetFileNameWithoutExt(const(char*) filePath);
/// Get full path for a given fileName with path (uses static string)
const(char*) GetDirectoryPath(const(char*) filePath);
/// Get previous directory path for a given path (uses static string)
const(char*) GetPrevDirectoryPath(const(char*) dirPath);
/// Get current working directory (uses static string)
const(char*) GetWorkingDirectory();
/// Get the directory if the running application (uses static string)
const(char*) GetApplicationDirectory();
/// Get filenames in a directory path (memory should be freed)
/// Deprecated: Removed in Raylib 4.2
char** GetDirectoryFiles(const(char*) dirPath, int* count);
/// Clear directory files paths buffers (free memory)
/// Deprecated: Removed in Raylib 4.2
void ClearDirectoryFiles();
/// Change working directory, return true on success
bool ChangeDirectory(const(char*) dir);
/// Check if a given path is a file or a directory
bool IsPathFile(const(char*) path);
/// Load directory filepaths
FilePathList LoadDirectoryFiles(const(char*) dirPath);
/// Load directory filepaths with extension filtering and recursive directory scan
FilePathList LoadDirectoryFilesEx(const(char*) basePath, const(char*) filter, bool scanSubdirs);
/// Unload filepaths
void UnloadDirectoryFiles(FilePathList files);
/// Check if a file has been dropped into window
bool IsFileDropped();
/// Get dropped files names (memory should be freed)
/// Deprecated: Removed in Raylib 4.2
char** GetDroppedFiles(int* count);
/// Clear dropped files paths buffer (free memory)
/// Deprecated: Removed in Raylib 4.2
void ClearDroppedFiles();
/// Load dropped filepaths
FilePathList LoadDroppedFiles();
/// Unload dropped filepaths
void UnloadDroppedFiles(FilePathList files);
/// Get file modification time (last write time)
long GetFileModTime(const(char*) fileName);

// Compression/Encoding functionality
/// Compress data (DEFLATE algorithm)
ubyte* CompressData(ubyte* data, int dataLength, int* compDataLength);
/// Decompress data (DEFLATE algorithm)
ubyte* DecompressData(ubyte* compData, int compDataLength, int* dataLength);
/// Encode data to Base64 string
char* EncodeDataBase64(const ubyte* data, int dataLength, int* outputLength);
/// Decode Base64 string data
ubyte* DecodeDataBase64(ubyte* data, int* outputLength);

// Persistent storage management
/// Save integer value to storage file (to defined position), returns true on success
bool SaveStorageValue(uint position, int value);
/// Load integer value from storage file (from defined position)
int LoadStorageValue(uint position);
/// Open URL with default system browser (if available)
void OpenURL(const(char*) url);

//------------------------------------------------------------------------------------
// Input Handling Functions (Module: core)
//------------------------------------------------------------------------------------

// Input-related functions: keyboard
/// Check if a key has been pressed once
bool IsKeyPressed(int key);
/// Check if a key is being pressed
bool IsKeyDown(int key);
/// Check if a key has been released once
bool IsKeyReleased(int key);
/// Check if a key is NOT being pressed
bool IsKeyUp(int key);
/// Set a custom key to exit program (default is ESC)
void SetExitKey(int key);
/// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
int GetKeyPressed();
/// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
int GetCharPressed();

// Input-related functions: gamepads
/// Check if a gamepad is available
bool IsGamepadAvailable(int gamepad);
/// Check gamepad name (if available)
/// Deprecated: Removed from Raylib `4.0.0`
bool IsGamepadName(int gamepad, const(char*) name);
/// Get gamepad internal name id
const(char*) GetGamepadName(int gamepad);
/// Check if a gamepad button has been pressed once
bool IsGamepadButtonPressed(int gamepad, int button);
/// Check if a gamepad button is being pressed
bool IsGamepadButtonDown(int gamepad, int button);
/// Check if a gamepad button has been released once
bool IsGamepadButtonReleased(int gamepad, int button);
/// Check if a gamepad button is NOT being pressed
bool IsGamepadButtonUp(int gamepad, int button);
/// Get the last gamepad button pressed
int GetGamepadButtonPressed();
/// Get gamepad axis count for a gamepad
int GetGamepadAxisCount(int gamepad);
/// Get axis movement value for a gamepad axis
float GetGamepadAxisMovement(int gamepad, int axis);
/// Set internal gamepad mappings (SDL_GameControllerDB)
int SetGamepadMappings(const(char*) mappings);

// Input-related functions: mouse
/// Check if a mouse button has been pressed once
bool IsMouseButtonPressed(int button);
/// Check if a mouse button is being pressed
bool IsMouseButtonDown(int button);
/// Check if a mouse button has been released once
bool IsMouseButtonReleased(int button);
/// Check if a mouse button is NOT being pressed
bool IsMouseButtonUp(int button);
/// Get mouse position X
int GetMouseX();
/// Get mouse position Y
int GetMouseY();
/// Get mouse position XY
Vector2 GetMousePosition();
/// Get mouse delta between frames
Vector2 GetMouseDelta();
/// Set mouse position XY
void SetMousePosition(int x, int y);
/// Set mouse offset
void SetMouseOffset(int offsetX, int offsetY);
/// Set mouse scaling
void SetMouseScale(float scaleX, float scaleY);
/// Get mouse wheel movement Y
float GetMouseWheelMove();
/// Set mouse cursor
void SetMouseCursor(int cursor);

// Input-related functions: touch
/// Get touch position X for touch point 0 (relative to screen size)
int GetTouchX();
/// Get touch position Y for touch point 0 (relative to screen size)
int GetTouchY();
/// Get touch position XY for a touch point index (relative to screen size)
Vector2 GetTouchPosition(int index);
/// Get touch point identifier for given index
int GetTouchPointId(int index);
/// Get number of touch points
int GetTouchPointCount();

//------------------------------------------------------------------------------------
// Gestures and Touch Handling Functions (Module: rgestures)
//------------------------------------------------------------------------------------
/// Enable a set of gestures using flags
void SetGesturesEnabled(uint flags);
/// Check if a gesture have been detected
bool IsGestureDetected(int gesture);
/// Get latest detected gesture
int GetGestureDetected();
/// Get gesture hold time in milliseconds
float GetGestureHoldDuration();
/// Get gesture drag vector
Vector2 GetGestureDragVector();
/// Get gesture drag angle
float GetGestureDragAngle();
/// Get gesture pinch delta
Vector2 GetGesturePinchVector();
/// Get gesture pinch angle
float GetGesturePinchAngle();

//------------------------------------------------------------------------------------
// Camera System Functions (Module: rcamera)
//------------------------------------------------------------------------------------
/// Set camera mode (multiple camera modes available)
void SetCameraMode(Camera camera, int mode);
/// Update camera position for selected mode
void UpdateCamera(Camera* camera);
/// Set camera pan key to combine with mouse movement (free camera)
void SetCameraPanControl(int keyPan);
/// Set camera alt key to combine with mouse movement (free camera)
void SetCameraAltControl(int keyAlt);
/// Set camera smooth zoom key to combine with mouse (free camera)
void SetCameraSmoothZoomControl(int keySmoothZoom);
/// Set camera move controls (1st person and 3rd person cameras)
void SetCameraMoveControls(int keyFront, int keyBack, int keyRight, int keyLeft,
	int keyUp, int keyDown);

//------------------------------------------------------------------------------------
// Basic Shapes Drawing Functions (Module: shapes)
//------------------------------------------------------------------------------------
// Set texture and rectangle to be used on shapes drawing
// NOTE: It can be useful when using basic shapes and one single font,
// defining a font char white rectangle would allow drawing everything in a single draw call
/// Set texture and rectangle to be used on shapes drawing
void SetShapesTexture(Texture2D texture, Rectangle source);

// Basic shapes drawing functions
/// Draw a pixel
void DrawPixel(int posX, int posY, Color color);
/// Draw a pixel (Vector version)
void DrawPixelV(Vector2 position, Color color);
/// Draw a line
void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, Color color);
/// Draw a line (Vector version)
void DrawLineV(Vector2 startPos, Vector2 endPos, Color color);
/// Draw a line defining thickness
void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color);
/// Draw a line using cubic-bezier curves in-out
void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color);
/// Draw line using quadratic bezier curves with a control point
void DrawLineBezierQuad(Vector2 startPos, Vector2 endPos, Vector2 controlPos,
	float thick, Color color);
/// Draw line using cubic bezier curves with 2 control points
void DrawLineBezierCubic(Vector2 startPos, Vector2 endPos,
	Vector2 startControlPos, Vector2 endControlPos, float thick, Color color);
/// Draw lines sequence
void DrawLineStrip(Vector2* points, int pointCount, Color color);
/// Draw a color-filled circle
void DrawCircle(int centerX, int centerY, float radius, Color color);
/// Draw a piece of a circle
void DrawCircleSector(Vector2 center, float radius, float startAngle,
	float endAngle, int segments, Color color);
/// Draw circle sector outline
void DrawCircleSectorLines(Vector2 center, float radius, float startAngle,
	float endAngle, int segments, Color color);
/// Draw a gradient-filled circle
void DrawCircleGradient(int centerX, int centerY, float radius, Color color1, Color color2);
/// Draw a color-filled circle (Vector version)
void DrawCircleV(Vector2 center, float radius, Color color);
/// Draw circle outline
void DrawCircleLines(int centerX, int centerY, float radius, Color color);
/// Draw ellipse
void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, Color color);
/// Draw ellipse outline
void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, Color color);
/// Draw ring
void DrawRing(Vector2 center, float innerRadius, float outerRadius,
	float startAngle, float endAngle, int segments, Color color);
/// Draw ring outline
void DrawRingLines(Vector2 center, float innerRadius, float outerRadius,
	float startAngle, float endAngle, int segments, Color color);
/// Draw a color-filled rectangle
void DrawRectangle(int posX, int posY, int width, int height, Color color);
/// Draw a color-filled rectangle (Vector version)
void DrawRectangleV(Vector2 position, Vector2 size, Color color);
/// Draw a color-filled rectangle
void DrawRectangleRec(Rectangle rec, Color color);
/// Draw a color-filled rectangle with pro parameters
void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color);
/// Draw a vertical-gradient-filled rectangle
void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2);
/// Draw a horizontal-gradient-filled rectangle
void DrawRectangleGradientH(int posX, int posY, int width, int height, Color color1, Color color2);
/// Draw a gradient-filled rectangle with custom vertex colors
void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4);
/// Draw rectangle outline
void DrawRectangleLines(int posX, int posY, int width, int height, Color color);
/// Draw rectangle outline with extended parameters
void DrawRectangleLinesEx(Rectangle rec, float lineThick, Color color);
/// Draw rectangle with rounded edges
void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color);
/// Draw rectangle with rounded edges outline
void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments,
	float lineThick, Color color);
/// Draw a color-filled triangle (vertex in counter-clockwise order!)
void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color);
/// Draw triangle outline (vertex in counter-clockwise order!)
void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color);
/// Draw a triangle fan defined by points (first vertex is the center)
void DrawTriangleFan(Vector2* points, int pointCount, Color color);
/// Draw a triangle strip defined by points
void DrawTriangleStrip(Vector2* points, int pointCount, Color color);
/// Draw a regular polygon (Vector version)
void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color);
/// Draw a polygon outline of n sides
void DrawPolyLines(Vector2 center, int sides, float radius, float rotation, Color color);
/// Draw a polygon outline of n sides with extended parameters
void DrawPolyLinesEx(Vector2 center, int sides, float radius, float rotation,
	float lineThick, Color color);

// Basic shapes collision detection functions
/// Check collision between two rectangles
bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2);
/// Check collision between two circles
bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2);
/// Check collision between circle and rectangle
bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec);
/// Check if point is inside rectangle
bool CheckCollisionPointRec(Vector2 point, Rectangle rec);
/// Check if point is inside circle
bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius);
/// Check if point is inside a triangle
bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3);
/// Check the collision between two lines defined by two points each, returns collision point by reference
bool CheckCollisionLines(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2,
	Vector2 endPos2, Vector2* collisionPoint);
/// Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
bool CheckCollisionPointLine(Vector2 point, Vector2 p1, Vector2 p2, int threshold);
/// Get collision rectangle for two rectangles collision
Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2);

//------------------------------------------------------------------------------------
// Texture Loading and Drawing Functions (Module: textures)
//------------------------------------------------------------------------------------

// Image loading functions
// NOTE: This functions do not require GPU access
/// Load image from file into CPU memory (RAM)
Image LoadImage(const(char*) fileName);
/// Load image from RAW file data
Image LoadImageRaw(const(char*) fileName, int width, int height, int format, int headerSize);
/// Load image sequence from file (frames appended to image.data)
Image LoadImageAnim(const(char*) fileName, int* frames);
/// Load image from memory buffer, fileType refers to extension: i.e. '.png'
Image LoadImageFromMemory(const(char*) fileType, const ubyte* fileData, int dataSize);
/// Load image from GPU texture data
Image LoadImageFromTexture(Texture2D texture);
/// Load image from screen buffer and (screenshot)
Image LoadImageFromScreen();
/// Unload image from CPU memory (RAM)
void UnloadImage(Image image);
/// Export image data to file, returns true on success
bool ExportImage(Image image, const(char*) fileName);
/// Export image as code file defining an array of bytes, returns true on success
bool ExportImageAsCode(Image image, const(char*) fileName);

// Image generation functions
/// Generate image: plain color
Image GenImageColor(int width, int height, Color color);
/// Generate image: vertical gradient
Image GenImageGradientV(int width, int height, Color top, Color bottom);
/// Generate image: horizontal gradient
Image GenImageGradientH(int width, int height, Color left, Color right);
/// Generate image: radial gradient
Image GenImageGradientRadial(int width, int height, float density, Color inner, Color outer);
/// Generate image: checked
Image GenImageChecked(int width, int height, int checksX, int checksY, Color col1, Color col2);
/// Generate image: white noise
Image GenImageWhiteNoise(int width, int height, float factor);
/// Generate image: cellular algorithm, bigger tileSize means bigger cells
Image GenImageCellular(int width, int height, int tileSize);

// Image manipulation functions
/// Create an image duplicate (useful for transformations)
Image ImageCopy(Image image);
/// Create an image from another image piece
Image ImageFromImage(Image image, Rectangle rec);
/// Create an image from text (default font)
Image ImageText(const(char*) text, int fontSize, Color color);
/// Create an image from text (custom sprite font)
Image ImageTextEx(Font font, const(char*) text, float fontSize, float spacing, Color tint);
/// Convert image data to desired format
void ImageFormat(Image* image, int newFormat);
/// Convert image to POT (power-of-two)
void ImageToPOT(Image* image, Color fill);
/// Crop an image to a defined rectangle
void ImageCrop(Image* image, Rectangle crop);
/// Crop image depending on alpha value
void ImageAlphaCrop(Image* image, float threshold);
/// Clear alpha channel to desired color
void ImageAlphaClear(Image* image, Color color, float threshold);
/// Apply alpha mask to image
void ImageAlphaMask(Image* image, Image alphaMask);
/// Premultiply alpha channel
void ImageAlphaPremultiply(Image* image);
/// Resize image (Bicubic scaling algorithm)
void ImageResize(Image* image, int newWidth, int newHeight);
/// Resize image (Nearest-Neighbor scaling algorithm)
void ImageResizeNN(Image* image, int newWidth, int newHeight);
/// Resize canvas and fill with color
void ImageResizeCanvas(Image* image, int newWidth, int newHeight, int offsetX,
	int offsetY, Color fill);
/// Compute all mipmap levels for a provided image
void ImageMipmaps(Image* image);
/// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
void ImageDither(Image* image, int rBpp, int gBpp, int bBpp, int aBpp);
/// Flip image vertically
void ImageFlipVertical(Image* image);
/// Flip image horizontally
void ImageFlipHorizontal(Image* image);
/// Rotate image clockwise 90deg
void ImageRotateCW(Image* image);
/// Rotate image counter-clockwise 90deg
void ImageRotateCCW(Image* image);
/// Modify image color: tint
void ImageColorTint(Image* image, Color color);
/// Modify image color: invert
void ImageColorInvert(Image* image);
/// Modify image color: grayscale
void ImageColorGrayscale(Image* image);
/// Modify image color: contrast (-100 to 100)
void ImageColorContrast(Image* image, float contrast);
/// Modify image color: brightness (-255 to 255)
void ImageColorBrightness(Image* image, int brightness);
/// Modify image color: replace color
void ImageColorReplace(Image* image, Color color, Color replace);
/// Load color data from image as a Color array (RGBA - 32bit)
Color* LoadImageColors(Image image);
/// Load colors palette from image as a Color array (RGBA - 32bit)
Color* LoadImagePalette(Image image, int maxPaletteSize, int* colorCount);
/// Unload color data loaded with LoadImageColors()
void UnloadImageColors(Color* colors);
/// Unload colors palette loaded with LoadImagePalette()
void UnloadImagePalette(Color* colors);
/// Get image alpha border rectangle
Rectangle GetImageAlphaBorder(Image image, float threshold);
/// Get image pixel color at (x, y) position
Color GetImageColor(Image image, int x, int y);

// Image drawing functions
// NOTE: Image software-rendering functions (CPU)
/// Clear image background with given color
void ImageClearBackground(Image* dst, Color color);
/// Draw pixel within an image
void ImageDrawPixel(Image* dst, int posX, int posY, Color color);
/// Draw pixel within an image (Vector version)
void ImageDrawPixelV(Image* dst, Vector2 position, Color color);
/// Draw line within an image
void ImageDrawLine(Image* dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color);
/// Draw line within an image (Vector version)
void ImageDrawLineV(Image* dst, Vector2 start, Vector2 end, Color color);
/// Draw circle within an image
void ImageDrawCircle(Image* dst, int centerX, int centerY, int radius, Color color);
/// Draw circle within an image (Vector version)
void ImageDrawCircleV(Image* dst, Vector2 center, int radius, Color color);
/// Draw rectangle within an image
void ImageDrawRectangle(Image* dst, int posX, int posY, int width, int height, Color color);
/// Draw rectangle within an image (Vector version)
void ImageDrawRectangleV(Image* dst, Vector2 position, Vector2 size, Color color);
/// Draw rectangle within an image
void ImageDrawRectangleRec(Image* dst, Rectangle rec, Color color);
/// Draw rectangle lines within an image
void ImageDrawRectangleLines(Image* dst, Rectangle rec, int thick, Color color);
/// Draw a source image within a destination image (tint applied to source)
void ImageDraw(Image* dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint);
/// Draw text (using default font) within an image (destination)
void ImageDrawText(Image* dst, const(char*) text, int posX, int posY, int fontSize, Color color);
/// Draw text (custom sprite font) within an image (destination)
void ImageDrawTextEx(Image* dst, Font font, const(char*) text, Vector2 position,
	float fontSize, float spacing, Color tint);

// Texture loading functions
// NOTE: These functions require GPU access
/// Load texture from file into GPU memory (VRAM)
Texture2D LoadTexture(const(char*) fileName);
/// Load texture from image data
Texture2D LoadTextureFromImage(Image image);
/// Load cubemap from image, multiple image cubemap layouts supported
TextureCubemap LoadTextureCubemap(Image image, int layout);
/// Load texture for rendering (framebuffer)
RenderTexture2D LoadRenderTexture(int width, int height);
/// Unload texture from GPU memory (VRAM)
void UnloadTexture(Texture2D texture);
/// Unload render texture from GPU memory (VRAM)
void UnloadRenderTexture(RenderTexture2D target);
/// Update GPU texture with new data
void UpdateTexture(Texture2D texture, const void* pixels);
/// Update GPU texture rectangle with new data
void UpdateTextureRec(Texture2D texture, Rectangle rec, const void* pixels);

// Texture configuration functions
/// Generate GPU mipmaps for a texture
void GenTextureMipmaps(Texture2D* texture);
/// Set texture scaling filter mode
void SetTextureFilter(Texture2D texture, int filter);
/// Set texture wrapping mode
void SetTextureWrap(Texture2D texture, int wrap);

/// Texture drawing functions
/// Draw a Texture2D
void DrawTexture(Texture2D texture, int posX, int posY, Color tint);
/// Draw a Texture2D with position defined as Vector2
void DrawTextureV(Texture2D texture, Vector2 position, Color tint);
/// Draw a Texture2D with extended parameters
void DrawTextureEx(Texture2D texture, Vector2 position, float rotation, float scale, Color tint);
/// Draw a part of a texture defined by a rectangle
void DrawTextureRec(Texture2D texture, Rectangle source, Vector2 position, Color tint);
/// Draw texture quad with tiling and offset parameters
void DrawTextureQuad(Texture2D texture, Vector2 tiling, Vector2 offset, Rectangle quad, Color tint);
/// Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
void DrawTextureTiled(Texture2D texture, Rectangle source, Rectangle dest,
	Vector2 origin, float rotation, float scale, Color tint);
/// Draw a part of a texture defined by a rectangle with 'pro' parameters
void DrawTexturePro(Texture2D texture, Rectangle source, Rectangle dest,
	Vector2 origin, float rotation, Color tint);
/// Draws a texture (or part of it) that stretches or shrinks nicely
void DrawTextureNPatch(Texture2D texture, NPatchInfo nPatchInfo, Rectangle dest,
	Vector2 origin, float rotation, Color tint);
/// Draw a textured polygon
void DrawTexturePoly(Texture2D texture, Vector2 center, Vector2* points,
	Vector2* texcoords, int pointCount, Color tint);

// Color/pixel related functions
/// Get color with alpha applied, alpha goes from 0.0f to 1.0f
Color Fade(Color color, float alpha);
/// Get hexadecimal value for a Color
int ColorToInt(Color color);
/// Get Color normalized as float [0..1]
Vector4 ColorNormalize(Color color);
/// Get Color from normalized values [0..1]
Color ColorFromNormalized(Vector4 normalized);
/// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
Vector3 ColorToHSV(Color color);
/// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
Color ColorFromHSV(float hue, float saturation, float value);
/// Get color with alpha applied, alpha goes from 0.0f to 1.0f
Color ColorAlpha(Color color, float alpha);
/// Get src alpha-blended into dst color with tint
Color ColorAlphaBlend(Color dst, Color src, Color tint);
/// Get Color structure from hexadecimal value
Color GetColor(uint hexValue);
/// Get Color from a source pixel pointer of certain format
Color GetPixelColor(void* srcPtr, int format);
/// Set color formatted into destination pixel pointer
void SetPixelColor(void* dstPtr, Color color, int format);
/// Get pixel data size in bytes for certain format
int GetPixelDataSize(int width, int height, int format);

///------------------------------------------------------------------------------------
/// Font Loading and Text Drawing Functions (Module: text)
///------------------------------------------------------------------------------------

// Font loading/unloading functions
/// Get the default Font
Font GetFontDefault();
/// Load font from file into GPU memory (VRAM)
Font LoadFont(const(char*) fileName);
/// Load font from file with extended parameters
Font LoadFontEx(const(char*) fileName, int fontSize, int* fontChars, int glyphCount);
/// Load font from Image (XNA style)
Font LoadFontFromImage(Image image, Color key, int firstChar);
/// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
Font LoadFontFromMemory(const(char*) fileType, const ubyte* fileData,
	int dataSize, int fontSize, int* fontChars, int glyphCount);
/// Load font data for further use
GlyphInfo* LoadFontData(const ubyte* fileData, int dataSize, int fontSize,
	int* fontChars, int glyphCount, int type);
/// Generate image font atlas using chars info
Image GenImageFontAtlas(const GlyphInfo* chars, Rectangle** recs,
	int glyphCount, int fontSize, int padding, int packMethod);
/// Unload font chars info data (RAM)
void UnloadFontData(GlyphInfo* chars, int glyphCount);
/// Unload Font from GPU memory (VRAM)
void UnloadFont(Font font);

// Text drawing functions
/// Draw current FPS
void DrawFPS(int posX, int posY);
/// Draw text (using default font)
void DrawText(const(char*) text, int posX, int posY, int fontSize, Color color);
/// Draw text using font and additional parameters
void DrawTextEx(Font font, const(char*) text, Vector2 position, float fontSize,
	float spacing, Color tint);
/// Draw text using Font and pro parameters (rotation)
void DrawTextPro(Font font, const(char*) text, Vector2 position, Vector2 origin,
	float rotation, float fontSize, float spacing, Color tint);
/// Draw one character (codepoint)
void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint);

// Text font info functions
/// Measure string width for default font
int MeasureText(const(char*) text, int fontSize);
/// Measure string size for Font
Vector2 MeasureTextEx(Font font, const(char*) text, float fontSize, float spacing);
/// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
int GetGlyphIndex(Font font, int codepoint);
/// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
GlyphInfo GetGlyphInfo(Font font, int codepoint);
/// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
Rectangle GetGlyphAtlasRec(Font font, int codepoint);

// Text codepoints management functions (unicode characters)
/// Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
int* LoadCodepoints(const(char*) text, int* count);
/// Unload codepoints data from memory
void UnloadCodepoints(int* codepoints);
/// Get total number of codepoints in a UTF-8 encoded string
int GetCodepointCount(const(char*) text);
/// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
int GetCodepoint(const(char*) text, int* bytesProcessed);
/// Encode one codepoint into UTF-8 byte array (array length returned as parameter)
const(char*) CodepointToUTF8(int codepoint, int* byteSize);
/// Encode text as codepoints array into UTF-8 text string (WARNING: memory must be freed!)
char* TextCodepointsToUTF8(int* codepoints, int length);

// Text strings management functions (no UTF-8 strings, only byte chars)
// NOTE: Some strings allocate memory internally for returned strings, just be careful!
/// Copy one string to another, returns bytes copied
int TextCopy(char* dst, const(char*) src);
/// Check if two text string are equal
bool TextIsEqual(const(char*) text1, const(char*) text2);
/// Get text length, checks for '\0' ending
uint TextLength(const(char*) text);
/// Text formatting with variables (sprintf() style)
const(char*) TextFormat(const(char*) text, ...);
/// Get a piece of a text string
const(char*) TextSubtext(const(char*) text, int position, int length);
/// Replace text string (WARNING: memory must be freed!)
char* TextReplace(char* text, const(char*) replace, const(char*) by);
/// Insert text in a position (WARNING: memory must be freed!)
char* TextInsert(const(char*) text, const(char*) insert, int position);
/// Join text strings with delimiter
const(char*) TextJoin(const(char*)* textList, int count, const(char*) delimiter);
/// Split text into multiple strings
const(char*)* TextSplit(const(char*) text, char delimiter, int* count);
/// Append text at specific position and move cursor!
void TextAppend(char* text, const(char*) append, int* position);
/// Find first text occurrence within a string
int TextFindIndex(const(char*) text, const(char*) find);
/// Get upper case version of provided string
const(char*) TextToUpper(const(char*) text);
/// Get lower case version of provided string
const(char*) TextToLower(const(char*) text);
/// Get Pascal case notation version of provided string
const(char*) TextToPascal(const(char*) text);
/// Get integer value from text (negative values not supported)
int TextToInteger(const(char*) text);

//------------------------------------------------------------------------------------
// Basic 3d Shapes Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Basic geometric 3D shapes drawing functions
/// Draw a line in 3D world space
void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color);
/// Draw a point in 3D space, actually a small line
void DrawPoint3D(Vector3 position, Color color);
/// Draw a circle in 3D world space
void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis,
	float rotationAngle, Color color);
/// Draw a color-filled triangle (vertex in counter-clockwise order!)
void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color);
/// Draw a triangle strip defined by points
void DrawTriangleStrip3D(Vector3* points, int pointCount, Color color);
/// Draw cube
void DrawCube(Vector3 position, float width, float height, float length, Color color);
/// Draw cube (Vector version)
void DrawCubeV(Vector3 position, Vector3 size, Color color);
/// Draw cube wires
void DrawCubeWires(Vector3 position, float width, float height, float length, Color color);
/// Draw cube wires (Vector version)
void DrawCubeWiresV(Vector3 position, Vector3 size, Color color);
/// Draw cube textured
void DrawCubeTexture(Texture2D texture, Vector3 position, float width,
	float height, float length, Color color);
/// Draw cube with a region of a texture
void DrawCubeTextureRec(Texture2D texture, Rectangle source, Vector3 position,
	float width, float height, float length, Color color);
/// Draw sphere
void DrawSphere(Vector3 centerPos, float radius, Color color);
/// Draw sphere with extended parameters
void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color);
/// Draw sphere wires
void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color);
/// Draw a cylinder/cone
void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom,
	float height, int slices, Color color);
/// Draw a cylinder with base at startPos and top at endPos
void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius,
	float endRadius, int sides, Color color);
/// Draw a cylinder/cone wires
void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom,
	float height, int slices, Color color);
/// Draw a cylinder wires with base at startPos and top at endPos
void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius,
	float endRadius, int sides, Color color);
/// Draw a plane XZ
void DrawPlane(Vector3 centerPos, Vector2 size, Color color);
/// Draw a ray line
void DrawRay(Ray ray, Color color);
/// Draw a grid (centered at (0, 0, 0))
void DrawGrid(int slices, float spacing);

//------------------------------------------------------------------------------------
// Model 3d Loading and Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Model management functions
/// Load model from files (meshes and materials)
Model LoadModel(const(char*) fileName);
/// Load model from generated mesh (default material)
Model LoadModelFromMesh(Mesh mesh);
/// Unload model (including meshes) from memory (RAM and/or VRAM)
void UnloadModel(Model model);
/// Unload model (but not meshes) from memory (RAM and/or VRAM)
void UnloadModelKeepMeshes(Model model);
/// Compute model bounding box limits (considers all meshes)
BoundingBox GetModelBoundingBox(Model model);

// Model drawing functions
/// Draw a model (with texture if set)
void DrawModel(Model model, Vector3 position, float scale, Color tint);
/// Draw a model with extended parameters
void DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis,
	float rotationAngle, Vector3 scale, Color tint);
/// Draw a model wires (with texture if set)
void DrawModelWires(Model model, Vector3 position, float scale, Color tint);
/// Draw a model wires (with texture if set) with extended parameters
void DrawModelWiresEx(Model model, Vector3 position, Vector3 rotationAxis,
	float rotationAngle, Vector3 scale, Color tint);
/// Draw bounding box (wires)
void DrawBoundingBox(BoundingBox box, Color color);
/// Draw a billboard texture
void DrawBillboard(Camera camera, Texture2D texture, Vector3 position, float size, Color tint);
/// Draw a billboard texture defined by source
void DrawBillboardRec(Camera camera, Texture2D texture, Rectangle source,
	Vector3 position, Vector2 size, Color tint);
/// Draw a billboard texture defined by source and rotation
void DrawBillboardPro(Camera camera, Texture2D texture, Rectangle source,
	Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint);

// Mesh management functions
/// Upload mesh vertex data in GPU and provide VAO/VBO ids
void UploadMesh(Mesh* mesh, bool dynamic);
/// Update mesh vertex data in GPU for a specific buffer index
void UpdateMeshBuffer(Mesh mesh, int index, void* data, int dataSize, int offset);
/// Unload mesh data from CPU and GPU
void UnloadMesh(Mesh mesh);
/// Draw a 3d mesh with material and transform
void DrawMesh(Mesh mesh, Material material, Matrix transform);
/// Draw multiple mesh instances with material and different transforms
void DrawMeshInstanced(Mesh mesh, Material material, Matrix* transforms, int instances);
/// Export mesh data to file, returns true on success
bool ExportMesh(Mesh mesh, const(char*) fileName);
/// Compute mesh bounding box limits
BoundingBox GetMeshBoundingBox(Mesh mesh);
/// Compute mesh tangents
void GenMeshTangents(Mesh* mesh);
/// Compute mesh binormals
void GenMeshBinormals(Mesh* mesh);

// Mesh generation functions
/// Generate polygonal mesh
Mesh GenMeshPoly(int sides, float radius);
/// Generate plane mesh (with subdivisions)
Mesh GenMeshPlane(float width, float length, int resX, int resZ);
/// Generate cuboid mesh
Mesh GenMeshCube(float width, float height, float length);
/// Generate sphere mesh (standard sphere)
Mesh GenMeshSphere(float radius, int rings, int slices);
/// Generate half-sphere mesh (no bottom cap)
Mesh GenMeshHemiSphere(float radius, int rings, int slices);
/// Generate cylinder mesh
Mesh GenMeshCylinder(float radius, float height, int slices);
/// Generate cone/pyramid mesh
Mesh GenMeshCone(float radius, float height, int slices);
/// Generate torus mesh
Mesh GenMeshTorus(float radius, float size, int radSeg, int sides);
/// Generate trefoil knot mesh
Mesh GenMeshKnot(float radius, float size, int radSeg, int sides);
/// Generate heightmap mesh from image data
Mesh GenMeshHeightmap(Image heightmap, Vector3 size);
/// Generate cubes-based map mesh from image data
Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize);

// Material loading/unloading functions
/// Load materials from model file
Material* LoadMaterials(const(char*) fileName, int* materialCount);
/// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
Material LoadMaterialDefault();
/// Unload material from GPU memory (VRAM)
void UnloadMaterial(Material material);
/// Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
void SetMaterialTexture(Material* material, int mapType, Texture2D texture);
/// Set material for a mesh
void SetModelMeshMaterial(Model* model, int meshId, int materialId);

// Model animations loading/unloading functions
/// Load model animations from file
ModelAnimation* LoadModelAnimations(const(char*) fileName, uint* animCount);
/// Update model animation pose
void UpdateModelAnimation(Model model, ModelAnimation anim, int frame);
/// Unload animation data
void UnloadModelAnimation(ModelAnimation anim);
/// Unload animation array data
void UnloadModelAnimations(ModelAnimation* animations, uint count);
/// Check model animation skeleton match
bool IsModelAnimationValid(Model model, ModelAnimation anim);

// Collision detection functions
/// Check collision between two spheres
bool CheckCollisionSpheres(Vector3 center1, float radius1, Vector3 center2, float radius2);
/// Check collision between two bounding boxes
bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2);
/// Check collision between box and sphere
bool CheckCollisionBoxSphere(BoundingBox box, Vector3 center, float radius);
/// Get collision info between ray and sphere
RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, float radius);
/// Get collision info between ray and box
RayCollision GetRayCollisionBox(Ray ray, BoundingBox box);
/// Get collision info between ray and model
RayCollision GetRayCollisionModel(Ray ray, Model model);
/// Get collision info between ray and mesh
RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix transform);
/// Get collision info between ray and triangle
RayCollision GetRayCollisionTriangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3);
/// Get collision info between ray and quad
RayCollision GetRayCollisionQuad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4);

//------------------------------------------------------------------------------------
// Audio Loading and Playing Functions (Module: audio)
//------------------------------------------------------------------------------------

alias AudioCallback = void function(void* bufferData, uint frames);

// Audio device management functions
/// Initialize audio device and context
void InitAudioDevice();
/// Close the audio device and context
void CloseAudioDevice();
/// Check if audio device has been initialized successfully
bool IsAudioDeviceReady();
/// Set master volume (listener)
void SetMasterVolume(float volume);

// Wave/Sound loading/unloading functions
/// Load wave data from file
Wave LoadWave(const(char*) fileName);
/// Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
Wave LoadWaveFromMemory(const(char*) fileType, const ubyte* fileData, int dataSize);
/// Load sound from file
Sound LoadSound(const(char*) fileName);
/// Load sound from wave data
Sound LoadSoundFromWave(Wave wave);
/// Update sound buffer with new data
void UpdateSound(Sound sound, const void* data, int sampleCount);
/// Unload wave data
void UnloadWave(Wave wave);
/// Unload sound
void UnloadSound(Sound sound);
/// Export wave data to file, returns true on success
bool ExportWave(Wave wave, const(char*) fileName);
/// Export wave sample data to code (.h), returns true on success
bool ExportWaveAsCode(Wave wave, const(char*) fileName);

// Wave/Sound management functions
/// Play a sound
void PlaySound(Sound sound);
/// Stop playing a sound
void StopSound(Sound sound);
/// Pause a sound
void PauseSound(Sound sound);
/// Resume a paused sound
void ResumeSound(Sound sound);
/// Play a sound (using multichannel buffer pool)
void PlaySoundMulti(Sound sound);
/// Stop any sound playing (using multichannel buffer pool)
void StopSoundMulti();
/// Get number of sounds playing in the multichannel
int GetSoundsPlaying();
/// Check if a sound is currently playing
bool IsSoundPlaying(Sound sound);
/// Set volume for a sound (1.0 is max level)
void SetSoundVolume(Sound sound, float volume);
/// Set pitch for a sound (1.0 is base level)
void SetSoundPitch(Sound sound, float pitch);
/// Set pan for a sound (0.5 is center)
void SetSoundPan(Sound sound, float pan);
/// Convert wave data to desired format
void WaveFormat(Wave* wave, int sampleRate, int sampleSize, int channels);
/// Copy a wave to a new wave
Wave WaveCopy(Wave wave);
/// Crop a wave to defined samples range
void WaveCrop(Wave* wave, int initSample, int finalSample);
/// Load samples data from wave as a floats array
float* LoadWaveSamples(Wave wave);
/// Unload samples data loaded with LoadWaveSamples()
void UnloadWaveSamples(float* samples);

// Music management functions
/// Load music stream from file
Music LoadMusicStream(const(char*) fileName);
/// Load music stream from data
Music LoadMusicStreamFromMemory(const(char*) fileType, ubyte* data, int dataSize);
/// Unload music stream
void UnloadMusicStream(Music music);
/// Start music playing
void PlayMusicStream(Music music);
/// Check if music is playing
bool IsMusicStreamPlaying(Music music);
/// Updates buffers for music streaming
void UpdateMusicStream(Music music);
/// Stop music playing
void StopMusicStream(Music music);
/// Pause music playing
void PauseMusicStream(Music music);
/// Resume playing paused music
void ResumeMusicStream(Music music);
/// Seek music to a position (in seconds)
void SeekMusicStream(Music music, float position);
/// Set volume for music (1.0 is max level)
void SetMusicVolume(Music music, float volume);
/// Set pitch for a music (1.0 is base level)
void SetMusicPitch(Music music, float pitch);
/// Set pan for a music (0.5 is center)
void SetMusicPan(Music music, float pan);
/// Get music time length (in seconds)
float GetMusicTimeLength(Music music);
/// Get current music time played (in seconds)
float GetMusicTimePlayed(Music music);

// AudioStream management functions
/// Load audio stream (to stream raw audio pcm data)
AudioStream LoadAudioStream(uint sampleRate, uint sampleSize, uint channels);
/// Unload audio stream and free memory
void UnloadAudioStream(AudioStream stream);
/// Update audio stream buffers with data
void UpdateAudioStream(AudioStream stream, const void* data, int frameCount);
/// Check if any audio stream buffers requires refill
bool IsAudioStreamProcessed(AudioStream stream);
/// Play audio stream
void PlayAudioStream(AudioStream stream);
/// Pause audio stream
void PauseAudioStream(AudioStream stream);
/// Resume audio stream
void ResumeAudioStream(AudioStream stream);
/// Check if audio stream is playing
bool IsAudioStreamPlaying(AudioStream stream);
/// Stop audio stream
void StopAudioStream(AudioStream stream);
/// Set volume for audio stream (1.0 is max level)
void SetAudioStreamVolume(AudioStream stream, float volume);
/// Set pitch for audio stream (1.0 is base level)
void SetAudioStreamPitch(AudioStream stream, float pitch);
/// Set pan for audio stream (0.5 is center)
void SetAudioStreamPan(AudioStream stream, float pan);
/// Default size for new audio streams
void SetAudioStreamBufferSizeDefault(int size);

/// Attach audio stream processor to stream
void AttachAudioStreamProcessor(AudioStream stream, AudioCallback processor);
/// Detach audio stream processor from stream
void DetachAudioStreamProcessor(AudioStream stream, AudioCallback processor);
