/// Simple demonstation of writing text to the screen with a custom sprite font.
///
/// Raylib is capable loading fonts from a variety of formats, image files being one
/// of them but with some precautions:
/// - The rectangles that define the separators for each character must have the __same pixel
/// siz in both width and height__.
/// - Said separators must use the color __magenta__ (hexadecimeal: 0xFF00FF).
import raylib;

void main()
{
    InitWindow(640, 480, "SpriteFont demonstration");
    SetTargetFPS(60);

    // Resources must be created
    auto spriteFont = LoadFont("assets/nes_font.png");

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(Colors.RAYWHITE);

        DrawTextEx(spriteFont, "This is an example in using a customized font that follows the",
                Vector2(0, 0), 8, 0, Colors.BLACK);
        DrawTextEx(spriteFont, "XNA spritefont convention.", Vector2(0, 8), 8, 0, Colors.BLACK);

        EndDrawing();
    }

    UnloadFont(spriteFont);
    CloseWindow();
}
