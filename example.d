import arsd.simpledisplay;
import arsd.nanovega;
import arsd.color;
import widgets;
import std.stdio: writeln;

/// Function to draw all implimented widgets to the NanoVega context.
void drawWindow(SimpleWindow swnd, NVGContext nvgc) {
    // Draw the background.
    nvgc.drawBackground(PointF(0, 0), SizeF(swnd.width, swnd.height));

    // Draw all checkbox states.
    nvgc.drawCheckBox(PointF(15, 15), SizeF(15, 15), UNCHECKED);
    nvgc.drawCheckBox(PointF(45, 15), SizeF(15, 15), CHECKED);
    nvgc.drawCheckBox(PointF(75, 15), SizeF(15, 15), HOVERED);
    nvgc.drawCheckBox(PointF(105, 15), SizeF(15, 15), ACTIVE);

    // Draw all button states.
    nvgc.drawButton("Button", PointF(15, 45), SizeF(105, 25));
    nvgc.drawButton("HoveredButton", PointF(15, 80), SizeF(105, 25), CENTER_VERTICAL | CENTER_HORIZONTAL | HOVERED);
    nvgc.drawButton("ActiveButton", PointF(15, 115), SizeF(105, 25), CENTER_VERTICAL | CENTER_HORIZONTAL | ACTIVE);

    // Draw boxes to show the alignment of text.
    nvgc.beginPath();
    nvgc.strokeColor = NVGColor.black;
    nvgc.strokeWidth = 1;
    nvgc.rect(swnd.width - 300 - 15, 0 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 150 - 15, 0 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 300 - 15, 50 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 150 - 15, 50 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 300 - 15, 100 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 150 - 15, 100 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 300 - 15, 150 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 150 - 15, 150 + 15, 150f, 50f);
    nvgc.rect(swnd.width - 225 - 15, 200 + 15, 150f, 50f);
    nvgc.stroke();

    // Draw all alignments of text labels.
    nvgc.drawTextLabel("Top Left", PointF(swnd.width - 300 - 15, 0 + 15), SizeF(150, 50), ALIGN_TOP | ALIGN_LEFT);
    nvgc.drawTextLabel("Top Right", PointF(swnd.width - 150 - 15, 0 + 15), SizeF(150, 50), ALIGN_TOP | ALIGN_RIGHT);
    nvgc.drawTextLabel("Middle Left", PointF(swnd.width - 300 - 15, 50 + 15), SizeF(150, 50), CENTER_VERTICAL | ALIGN_LEFT);
    nvgc.drawTextLabel("Middle Right", PointF(swnd.width - 150 - 15, 50 + 15), SizeF(150, 50), CENTER_VERTICAL | ALIGN_RIGHT);
    nvgc.drawTextLabel("Bottom Left", PointF(swnd.width - 300 - 15, 100 + 15), SizeF(150, 50), ALIGN_BOTTOM | ALIGN_LEFT);
    nvgc.drawTextLabel("Bottom Right", PointF(swnd.width - 150 - 15, 100 + 15), SizeF(150, 50), ALIGN_BOTTOM | ALIGN_RIGHT);
    nvgc.drawTextLabel("Top Middle", PointF(swnd.width - 300 - 15, 150 + 15), SizeF(150, 50), ALIGN_TOP | CENTER_HORIZONTAL);
    nvgc.drawTextLabel("Bottom Middle", PointF(swnd.width - 150 - 15, 150 + 15), SizeF(150, 50), ALIGN_BOTTOM | CENTER_HORIZONTAL);
    nvgc.drawTextLabel("Center", PointF(swnd.width - 225 - 15, 200 + 15), SizeF(150, 50), CENTER_VERTICAL | CENTER_HORIZONTAL);

}

void main() {
    NVGContext nvgc;

    setOpenGLContextVersion(3, 0);
    initGlobalThemes();

    auto swnd = new SimpleWindow(1280, 720, "New Style Widgets", OpenGlOptions.yes, Resizability.allowResizing);

    swnd.minWidth = 768;
    swnd.minHeight = 432;

    swnd.onClosing = delegate() { nvgc.kill(); };

    swnd.visibleForTheFirstTime = delegate() {
        nvgc = nvgCreateContext();

        if (nvgc is null)
            assert(0, "Cannot initialize Nanovega context.");
    };

    swnd.redrawOpenGlScene = delegate() {
        glViewport(0, 0, swnd.width, swnd.height);
        glClearColor(0, 0, 0, 0);
        glClear(glNVGClearFlags);

        nvgc.beginFrame(swnd.width, swnd.height);
        scope (exit)
            nvgc.endFrame();

        drawWindow(swnd, nvgc);
    };

    swnd.eventLoop(0, delegate(KeyEvent event) {
        if (event == "Escape") {
            swnd.close();
            return;
        }
    });

    flushGui();
}
