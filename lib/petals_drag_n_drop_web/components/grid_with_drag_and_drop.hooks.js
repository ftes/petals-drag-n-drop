export const GridWithDragAndDrop = {
    mounted() {
        window.phxHooks ||= {}
        window.phxHooks.GridWithDragAndDrop ||= {}
        window.phxHooks.GridWithDragAndDrop[this.el.id] = this
    }
}
