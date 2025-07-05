import { Hooks } from 'ckeditor5-phoenix';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';

const csrfToken = document.querySelector('meta[name=\'csrf-token\']')!.getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    ...Hooks,
  },
});

liveSocket.connect();
