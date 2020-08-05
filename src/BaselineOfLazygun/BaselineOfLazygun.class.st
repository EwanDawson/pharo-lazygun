Class {
	#name : #BaselineOfLazygun,
	#superclass : #BaselineOf,
	#category : #BaselineOfLazygun
}

{ #category : #baselines }
BaselineOfLazygun >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'Lazygun' ]
]

{ #category : #accessing }
BaselineOfLazygun >> projectClass [ 
	^ MetacelloCypressBaselineProject 
]
