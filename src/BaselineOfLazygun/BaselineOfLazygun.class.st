"
I am a Baseline for loading Lazygun using Montecello. See my superclass for instructions on how to use me.
"
Class {
	#name : #BaselineOfLazygun,
	#superclass : #BaselineOf,
	#category : #BaselineOfLazygun
}

{ #category : #baselines }
BaselineOfLazygun >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self systemInteractionWith: spec.
			spec
				package: 'Lazygun'
					with: [ spec requires: #('SystemInteraction') ];
				package: 'Lazygun-Patches' ]
]

{ #category : #accessing }
BaselineOfLazygun >> projectClass [ 
	^ MetacelloCypressBaselineProject 
]

{ #category : #dependencies }
BaselineOfLazygun >> systemInteractionWith: spec [
	spec
		baseline: 'SystemInteraction'
		with: [ spec repository: 'github://jecisc/SystemInteraction:v1.0.1/src' ]
]
