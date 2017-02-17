///<reference path='sse.d.ts'/>
import { Observable } from 'rxjs';

export function fromEventSource<T>(url: string, options?: sse.IEventSourceInit) {
    return new Observable<T>((subscriber) => {
        const eventSource = new EventSource(url, options);
        eventSource.onmessage = x => subscriber.next(JSON.parse(x.data));
        eventSource.onerror = x => subscriber.error(x);
    });
}
