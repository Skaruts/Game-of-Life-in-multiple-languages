import random
import sksfml, cellmap


proc handle_input(window:RenderWindow) =
    var event:Event
    while window.poll_event(event):
        case event.kind
            of EventType.Closed:
                window.close()
            of EventType.KeyPressed:
                case event.key.code
                    of KeyCode.Escape:  window.close()
                    of KeyCode.Q:       window.close()
                    of KeyCode.Enter:   randomize_cells()
                    of KeyCode.Space:   toggle_pause()
                    of KeyCode.G:
                        if paused: next_generation()
                    else:               discard
            else: discard


proc main() =
    var window = sf_RenderWindow( video_mode(cint(SW), cint(SH)), "Game Of Life (nim-csfml)" )
    # window.vertical_sync_enabled = true
    window.framerateLimit = 60
    randomize(-1)

    init_cells()
    randomize_cells()

    # Cellmap loop, draws each frame
    while window.open:
        handle_input(window)

        window.clear(Black)

        if not paused:
            next_generation()
        render(window)

        window.display()

    # clean up stuff
    destroy() # cleans cellmap stuff
    window.destroy()
main()
