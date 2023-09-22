.SILENT:

sample:
	mint run xcodegen xcodegen generate --spec SampleApp/project.yml
	xed SampleApp/*.xcodeproj

lint:
	swift run swiftlint

autocorrect:
	swift run swiftlint --fix
