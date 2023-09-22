project_name = AssetCatalogConverter
executable_name = asset-catalog-converter

.SILENT:
.PHONY : demo sample lint autocorrect release formula

demo:
	swift run asset-catalog-converter SampleApp

sample:
	mint run xcodegen xcodegen generate --spec SampleApp/project.yml
	xed SampleApp/*.xcodeproj

lint:
	swift run swiftlint

autocorrect:
	swift run swiftlint --fix

release:
	scripts/release.sh ${executable_name}

formula:
	scripts/update_formula.sh ${project_name} ${executable_name}
