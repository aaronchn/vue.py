from vue import VueComponent


class Modal(VueComponent):
    template = "#modal-template"


Modal.register()


class App(VueComponent):
    show_modal = False


App("#app")
