import { application } from "controllers/application";
import RevealController from '@stimulus-components/reveal'
import Clipboard from '@stimulus-components/clipboard'
import Notification from '@stimulus-components/notification'
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

application.register('reveal', RevealController)
application.register('clipboard', Clipboard)
application.register('notification', Notification)

eagerLoadControllersFrom("controllers", application)
