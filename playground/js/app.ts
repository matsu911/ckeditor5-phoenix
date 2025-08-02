import { CustomEditorPluginsRegistry, Hooks } from 'ckeditor5-phoenix';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';

CustomEditorPluginsRegistry.the.register('HelloWorldPlugin', async () => {
  const { Plugin } = await import('ckeditor5');

  return class HelloWorldPlugin extends Plugin {
    static get pluginName() {
      return 'HelloWorldPlugin';
    }

    init() {
      // eslint-disable-next-line no-console
      console.info('Hello, World! Plugin initialized.');
    }
  };
});

const csrfToken = document.querySelector('meta[name=\'csrf-token\']')!.getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    ...Hooks,
  },
});

liveSocket.connect();
