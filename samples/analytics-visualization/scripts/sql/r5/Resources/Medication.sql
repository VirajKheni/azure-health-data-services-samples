CREATE EXTERNAL TABLE [fhir].[Medication] (
    [resourceType] NVARCHAR(4000),
    [id] VARCHAR(64),
    [meta.id] NVARCHAR(100),
    [meta.extension] NVARCHAR(MAX),
    [meta.versionId] VARCHAR(64),
    [meta.lastUpdated] VARCHAR(64),
    [meta.source] VARCHAR(256),
    [meta.profile] VARCHAR(MAX),
    [meta.security] VARCHAR(MAX),
    [meta.tag] VARCHAR(MAX),
    [implicitRules] VARCHAR(256),
    [language] NVARCHAR(100),
    [text.id] NVARCHAR(100),
    [text.extension] NVARCHAR(MAX),
    [text.status] NVARCHAR(64),
    [text.div] NVARCHAR(MAX),
    [extension] NVARCHAR(MAX),
    [modifierExtension] NVARCHAR(MAX),
    [identifier] VARCHAR(MAX),
    [code.id] NVARCHAR(100),
    [code.extension] NVARCHAR(MAX),
    [code.coding] VARCHAR(MAX),
    [code.text] NVARCHAR(4000),
    [status] NVARCHAR(100),
    [marketingAuthorizationHolder.id] NVARCHAR(100),
    [marketingAuthorizationHolder.extension] NVARCHAR(MAX),
    [marketingAuthorizationHolder.reference] NVARCHAR(4000),
    [marketingAuthorizationHolder.type] VARCHAR(256),
    [marketingAuthorizationHolder.identifier.id] NVARCHAR(100),
    [marketingAuthorizationHolder.identifier.extension] NVARCHAR(MAX),
    [marketingAuthorizationHolder.identifier.use] NVARCHAR(64),
    [marketingAuthorizationHolder.identifier.type] NVARCHAR(MAX),
    [marketingAuthorizationHolder.identifier.system] VARCHAR(256),
    [marketingAuthorizationHolder.identifier.value] NVARCHAR(4000),
    [marketingAuthorizationHolder.identifier.period] NVARCHAR(MAX),
    [marketingAuthorizationHolder.identifier.assigner] NVARCHAR(MAX),
    [marketingAuthorizationHolder.display] NVARCHAR(4000),
    [doseForm.id] NVARCHAR(100),
    [doseForm.extension] NVARCHAR(MAX),
    [doseForm.coding] VARCHAR(MAX),
    [doseForm.text] NVARCHAR(4000),
    [totalVolume.id] NVARCHAR(100),
    [totalVolume.extension] NVARCHAR(MAX),
    [totalVolume.numerator.id] NVARCHAR(100),
    [totalVolume.numerator.extension] NVARCHAR(MAX),
    [totalVolume.numerator.value] float,
    [totalVolume.numerator.comparator] NVARCHAR(64),
    [totalVolume.numerator.unit] NVARCHAR(100),
    [totalVolume.numerator.system] VARCHAR(256),
    [totalVolume.numerator.code] NVARCHAR(4000),
    [totalVolume.denominator.id] NVARCHAR(100),
    [totalVolume.denominator.extension] NVARCHAR(MAX),
    [totalVolume.denominator.value] float,
    [totalVolume.denominator.comparator] NVARCHAR(64),
    [totalVolume.denominator.unit] NVARCHAR(100),
    [totalVolume.denominator.system] VARCHAR(256),
    [totalVolume.denominator.code] NVARCHAR(4000),
    [ingredient] VARCHAR(MAX),
    [batch.id] NVARCHAR(100),
    [batch.extension] NVARCHAR(MAX),
    [batch.modifierExtension] NVARCHAR(MAX),
    [batch.lotNumber] NVARCHAR(100),
    [batch.expirationDate] VARCHAR(64),
) WITH (
    LOCATION='/Medication/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.MedicationIdentifier AS
SELECT
    [id],
    [identifier.JSON],
    [identifier.id],
    [identifier.extension],
    [identifier.use],
    [identifier.type.id],
    [identifier.type.extension],
    [identifier.type.coding],
    [identifier.type.text],
    [identifier.system],
    [identifier.value],
    [identifier.period.id],
    [identifier.period.extension],
    [identifier.period.start],
    [identifier.period.end],
    [identifier.assigner.id],
    [identifier.assigner.extension],
    [identifier.assigner.reference],
    [identifier.assigner.type],
    [identifier.assigner.identifier],
    [identifier.assigner.display]
FROM openrowset (
        BULK 'Medication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [identifier.JSON]  VARCHAR(MAX) '$.identifier'
    ) AS rowset
    CROSS APPLY openjson (rowset.[identifier.JSON]) with (
        [identifier.id]                NVARCHAR(100)       '$.id',
        [identifier.extension]         NVARCHAR(MAX)       '$.extension',
        [identifier.use]               NVARCHAR(64)        '$.use',
        [identifier.type.id]           NVARCHAR(100)       '$.type.id',
        [identifier.type.extension]    NVARCHAR(MAX)       '$.type.extension',
        [identifier.type.coding]       NVARCHAR(MAX)       '$.type.coding',
        [identifier.type.text]         NVARCHAR(4000)      '$.type.text',
        [identifier.system]            VARCHAR(256)        '$.system',
        [identifier.value]             NVARCHAR(4000)      '$.value',
        [identifier.period.id]         NVARCHAR(100)       '$.period.id',
        [identifier.period.extension]  NVARCHAR(MAX)       '$.period.extension',
        [identifier.period.start]      VARCHAR(64)         '$.period.start',
        [identifier.period.end]        VARCHAR(64)         '$.period.end',
        [identifier.assigner.id]       NVARCHAR(100)       '$.assigner.id',
        [identifier.assigner.extension] NVARCHAR(MAX)       '$.assigner.extension',
        [identifier.assigner.reference] NVARCHAR(4000)      '$.assigner.reference',
        [identifier.assigner.type]     VARCHAR(256)        '$.assigner.type',
        [identifier.assigner.identifier] NVARCHAR(MAX)       '$.assigner.identifier',
        [identifier.assigner.display]  NVARCHAR(4000)      '$.assigner.display'
    ) j

GO

CREATE VIEW fhir.MedicationIngredient AS
SELECT
    [id],
    [ingredient.JSON],
    [ingredient.id],
    [ingredient.extension],
    [ingredient.modifierExtension],
    [ingredient.item.id],
    [ingredient.item.extension],
    [ingredient.item.concept],
    [ingredient.item.reference],
    [ingredient.isActive],
    [ingredient.strength.ratio.id],
    [ingredient.strength.ratio.extension],
    [ingredient.strength.ratio.numerator],
    [ingredient.strength.ratio.denominator],
    [ingredient.strength.codeableConcept.id],
    [ingredient.strength.codeableConcept.extension],
    [ingredient.strength.codeableConcept.coding],
    [ingredient.strength.codeableConcept.text],
    [ingredient.strength.quantity.id],
    [ingredient.strength.quantity.extension],
    [ingredient.strength.quantity.value],
    [ingredient.strength.quantity.comparator],
    [ingredient.strength.quantity.unit],
    [ingredient.strength.quantity.system],
    [ingredient.strength.quantity.code]
FROM openrowset (
        BULK 'Medication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [ingredient.JSON]  VARCHAR(MAX) '$.ingredient'
    ) AS rowset
    CROSS APPLY openjson (rowset.[ingredient.JSON]) with (
        [ingredient.id]                NVARCHAR(100)       '$.id',
        [ingredient.extension]         NVARCHAR(MAX)       '$.extension',
        [ingredient.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [ingredient.item.id]           NVARCHAR(100)       '$.item.id',
        [ingredient.item.extension]    NVARCHAR(MAX)       '$.item.extension',
        [ingredient.item.concept]      NVARCHAR(MAX)       '$.item.concept',
        [ingredient.item.reference]    NVARCHAR(MAX)       '$.item.reference',
        [ingredient.isActive]          bit                 '$.isActive',
        [ingredient.strength.ratio.id] NVARCHAR(100)       '$.strength.ratio.id',
        [ingredient.strength.ratio.extension] NVARCHAR(MAX)       '$.strength.ratio.extension',
        [ingredient.strength.ratio.numerator] NVARCHAR(MAX)       '$.strength.ratio.numerator',
        [ingredient.strength.ratio.denominator] NVARCHAR(MAX)       '$.strength.ratio.denominator',
        [ingredient.strength.codeableConcept.id] NVARCHAR(100)       '$.strength.codeableConcept.id',
        [ingredient.strength.codeableConcept.extension] NVARCHAR(MAX)       '$.strength.codeableConcept.extension',
        [ingredient.strength.codeableConcept.coding] NVARCHAR(MAX)       '$.strength.codeableConcept.coding',
        [ingredient.strength.codeableConcept.text] NVARCHAR(4000)      '$.strength.codeableConcept.text',
        [ingredient.strength.quantity.id] NVARCHAR(100)       '$.strength.quantity.id',
        [ingredient.strength.quantity.extension] NVARCHAR(MAX)       '$.strength.quantity.extension',
        [ingredient.strength.quantity.value] float               '$.strength.quantity.value',
        [ingredient.strength.quantity.comparator] NVARCHAR(64)        '$.strength.quantity.comparator',
        [ingredient.strength.quantity.unit] NVARCHAR(100)       '$.strength.quantity.unit',
        [ingredient.strength.quantity.system] VARCHAR(256)        '$.strength.quantity.system',
        [ingredient.strength.quantity.code] NVARCHAR(4000)      '$.strength.quantity.code'
    ) j