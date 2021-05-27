// Paste the following code in the console (right click > inspect element, then click on the Console tab) on the Edpuzzle page
// From: https://gist.github.com/SheepTester/a5009c402d58117b167049faa274de52#:~:text=Edpuzzle%20aggressively%20reverts%20the%20playbackRate,is%20necessary%20to%20combat%20it.

speed = 2 // Change this to the speed (eg 2 for 2x speed)
video = document.querySelector('video')
Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, 'playbackRate').set.call(video, speed)
Object.defineProperty(video, 'playbackRate', { writable: false })
