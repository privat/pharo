Extension { #name : #RBCodeSnippet }

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippet >> compile [

	^ [ OpalCompiler new
		  permitFaulty: true;
		  noPattern: isMethod not;
		  compile: self source ]
	on: CodeError do: [ :e |
		"Compilation should success, because its the *faulty* mode".
		"If this is expected, then just return nil"
		self ifSkip: #compile then: [^ nil ].
		"Otherwise, pass the error"
		e pass ]
]

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippet >> compileOnError: aBlock [

	^ [ OpalCompiler new
		  noPattern: isMethod not;
		  compile: self source ] on: CodeError do: [ :e | aBlock cull: e ]
]

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippet >> doSemanticAnalysis [

	"Do the semantic analysis as with the compiler and return the AST of the whole method (possibly a DoIt method)"

	"The responsability of scope and context is far from clear.
	* using `RBMethodNode>>#doSemanticAnalysis` we cannot configure it.
	* using `OCASTSemanticAnalyzer` just fails on uninitialised internal thing.
	So just ask the compiler."

	^ OpalCompiler new
		  noPattern: isMethod not;
		  parse: self source "Note: `parse:` also does the semantic analysis and return the AST"
]

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippet >> doSemanticAnalysisOnError: aBlock [

	^ [ OpalCompiler new
		  noPattern: isMethod not;
		  permitFaulty: false;
		  parse: self source ] on: CodeError do: [ :e | aBlock value: e ]
]
