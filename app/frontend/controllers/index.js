import { application } from "./application";
import { registerControllers } from "stimulus-vite-helpers";
import RevealController from '@stimulus-components/reveal'
import Clipboard from '@stimulus-components/clipboard'
import Notification from '@stimulus-components/notification'

application.register('reveal', RevealController)
application.register('clipboard', Clipboard)
application.register('notification', Notification)

const controllers = import.meta.glob("./**/*_controller.js", { eager: true });
registerControllers(application, controllers);
