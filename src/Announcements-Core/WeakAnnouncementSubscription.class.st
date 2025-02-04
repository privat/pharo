"
A WeakAnnouncementSubscription is a subscription which is removed automatically when the subscriber is unreferenced.

No support for ephemerons currently prevents this from working for Block actions (blocks hold their receiver, which is the default subscriber strongly). 

To switch between subscription types, use makeStrong/makeWeak on the subscription returned when initially registering with announcer.


Note, that list and next must be first instance variables.
"
Class {
	#name : #WeakAnnouncementSubscription,
	#superclass : #AbstractAnnouncementSubscription,
	#type : #weak,
	#instVars : [
		'list',
		'next'
	],
	#classVars : [
		'FinalizationList'
	],
	#category : #'Announcements-Core-Subscription'
}

{ #category : #finalization }
WeakAnnouncementSubscription class >> finalizationList [

	^ FinalizationList ifNil: [ FinalizationList := WeakFinalizationList new ]
]

{ #category : #finalization }
WeakAnnouncementSubscription class >> finalizeValues [

	| head |

	head := self finalizationList swapWithNil.

	[ head notNil ] whileTrue: [
		head finalize.
		head := head next
	]
]

{ #category : #'instance creation' }
WeakAnnouncementSubscription class >> new [
	^ (self basicNew: 1) initialize
]

{ #category : #finalization }
WeakAnnouncementSubscription >> finalizationRegistry [
	^ FinalizationRegistry default
]

{ #category : #finalization }
WeakAnnouncementSubscription >> finalize [

	announcer removeSubscription: self
]

{ #category : #initialization }
WeakAnnouncementSubscription >> initialize [
	list := self class finalizationList
]

{ #category : #converting }
WeakAnnouncementSubscription >> makeStrong [

	| sub |
	sub := self subscriber.
	sub ifNil: [ ^ self error: 'Subscriber is nil, cannot make strong subscription' ].

	self unregister.

	^ self becomeForward: (AnnouncementSubscription new
		announcer: announcer;
		action: action asMessageSend;
		subscriber: sub;
		announcementClass: announcementClass)
]

{ #category : #converting }
WeakAnnouncementSubscription >> makeWeak [
	^ self
]

{ #category : #accessing }
WeakAnnouncementSubscription >> next [
	^ next
]

{ #category : #finalization }
WeakAnnouncementSubscription >> register [

	self finalizationRegistry add: self subscriber finalizer: self
]

{ #category : #accessing }
WeakAnnouncementSubscription >> subscriber [

	^ self basicAt: 1
]

{ #category : #accessing }
WeakAnnouncementSubscription >> subscriber: anObject [

	self subscriber ifNotNil: [ self error: 'subscriber already set' ].
	self basicAt: 1 put: anObject.
	self register
]

{ #category : #finalization }
WeakAnnouncementSubscription >> unregister [

	self subscriber ifNotNil: [:sub |  self finalizationRegistry remove: sub ]
]
