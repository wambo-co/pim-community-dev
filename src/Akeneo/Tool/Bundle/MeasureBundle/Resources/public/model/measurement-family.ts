import {getLabel} from 'pimui/js/i18n';
import {Direction} from 'akeneomeasure/shared/components/Caret';

type LocaleCode = string;

type Operation = {
  operator: string;
  value: string;
};

type Unit = {
  code: string;
  labels: {
    [locale: string]: string;
  };
  symbol: string;
  convert_from_standard: Operation[];
};

export type MeasurementFamily = {
  code: string;
  labels: {
    [locale: string]: string;
  };
  standard_unit_code: string;
  units: Unit[];
};

export const getMeasurementFamilyLabel = (measurementFamily: MeasurementFamily, locale: LocaleCode) =>
  getLabel(measurementFamily.labels, locale, measurementFamily.code);

export const getUnitLabel = (unit: Unit, locale: LocaleCode) => getLabel(unit.labels, locale, unit.code);

export const getStandardUnitLabel = (measurementFamily: MeasurementFamily, locale: LocaleCode) => {
  const unit = measurementFamily.units.find(unit => unit.code === measurementFamily.standard_unit_code);

  if (undefined === unit) return `[${measurementFamily.standard_unit_code}]`;

  return getUnitLabel(unit, locale);
};

export const filterMeasurementFamily = (
  measurementFamily: MeasurementFamily,
  searchValue: string,
  locale: LocaleCode
): boolean =>
  -1 !== measurementFamily.code.toLowerCase().indexOf(searchValue.toLowerCase()) ||
  (undefined !== measurementFamily.labels[locale] &&
    -1 !== measurementFamily.labels[locale].toLowerCase().indexOf(searchValue.toLowerCase()));

export const sortMeasurementFamily = (sortDirection: Direction, locale: LocaleCode, sortColumn: string) => (
  first: MeasurementFamily,
  second: MeasurementFamily
) => {
  const directionInverter = sortDirection === Direction.Descending ? -1 : 1;

  switch (sortColumn) {
    case 'label':
      return (
        directionInverter *
        getMeasurementFamilyLabel(first, locale).localeCompare(getMeasurementFamilyLabel(second, locale))
      );
    case 'code':
      return directionInverter * first.code.localeCompare(second.code);
    case 'standard_unit':
      return (
        directionInverter * getStandardUnitLabel(first, locale).localeCompare(getStandardUnitLabel(second, locale))
      );
    case 'unit_count':
      return directionInverter * (first.units.length - second.units.length);
    default:
      return 1;
  }
};
