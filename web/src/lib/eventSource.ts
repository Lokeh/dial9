///<reference path='sse.d.ts'/>
import { Observable } from 'rxjs';

export function fromEventSource(url: string, options?: sse.IEventSourceInit) {
    return new Observable<Event | sse.IOnMessageEvent>((subscriber) => {
        const eventSource = new EventSource(url, options);
        eventSource.onopen = x => subscriber.next(x);
        eventSource.onmessage = x => subscriber.next(x);
        eventSource.onerror = x => subscriber.error(x);
    });
}
