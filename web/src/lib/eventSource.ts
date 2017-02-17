///<reference path='sse.d.ts'/>
import { Observable } from 'rxjs';

export function fromEventSource(url: string) {
    return new Observable((subscriber) => {
        const eventSource = new EventSource(url)
        eventSource.onmessage = x => subscriber.next(x);
        eventSource.onerror = x => subscriber.error(x);
    });
}
