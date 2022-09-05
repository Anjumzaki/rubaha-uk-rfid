/* eslint no-restricted-globals: "off" */
const bigInt = require('big-integer');

const header = '00110000';
const partition = {
  bits: {
    company: [40, 37, 34, 30, 27, 24, 20],
    reference: [4, 7, 10, 14, 17, 20, 24]
  },
  digits: {
    company: [12, 11, 10, 9, 8, 7, 6],
    reference: [1, 2, 3, 4, 5, 6, 7]
  }
};

function BitsHelper(val, len, valbase = 16) {
  this.val = val;
  this.bitlength = len;

  this.bits = bigInt(val, valbase).toString(2);
  this.bits = Array(len - this.bits.length + 1).join('0') + this.bits;
}
function encode(sku, serial, companyLength = 7, filter = 1) {
  const header = '00110000';
  const partition = {
    bits: {
      company: [40, 37, 34, 30, 27, 24, 20],
      reference: [4, 7, 10, 14, 17, 20, 24]
    },
    digits: {
      company: [12, 11, 10, 9, 8, 7, 6],
      reference: [1, 2, 3, 4, 5, 6, 7]
    }
  }


  let epc = '';
  epc += header;
  const filterBinary = parseInt(filter, 10).toString(2);
  epc += Array(3 - filterBinary.length + 1).join('0') + filterBinary
  const currentPartition = partition.digits.company.indexOf(companyLength);
  const currentPartitionBinary = currentPartition.toString(2);
  epc += Array(3 - currentPartitionBinary.length + 1).join('0') + currentPartitionBinary
  const companyPrefix = sku.substr(1, companyLength)
  const companyPrefixBinary = parseInt(companyPrefix, 10).toString(2);
  epc += Array(24 - companyPrefixBinary.length + 1).join('0') + companyPrefixBinary
  const itemReference = sku.substr(0, 1) + sku.substr(companyLength + 1, sku.length - companyLength - 2)
  const itemReferenceBinary = parseInt(itemReference, 10).toString(2);
  epc += Array(20 - itemReferenceBinary.length + 1).join('0') + itemReferenceBinary
  const serialBinary = parseInt(serial, 10).toString(2);
  epc += Array(38 - serialBinary.length + 1).join('0') + serialBinary
  return bigInt(epc, 2).toString(16).toUpperCase();
}

function getCheckDigit(key) {
  const paddedKey = key.padStart(18, '0')
  const numbers = paddedKey.split('').map(n => parseInt(n))
  const sum = numbers.reduce((acc, n, i) => {
    acc += i % 2 ? n * 3 : n;
    return acc
  }, 0)
  const next = Math.ceil(sum / 10) * 10;
  return next - sum;
}

function parse(epc) {
  const parts = {
    Header: undefined,
    Filter: undefined,
    Partition: undefined,
    CompanyPrefix: undefined,
    ItemReference: undefined,
    SerialNumber: undefined,
    SerialReference: undefined,
    LocationReference: undefined,
    Extension: undefined,
    AssetType: undefined,
    IndividualAssetReference: undefined,
    ServiceReference: undefined,
    DocumentType: undefined,
    ManagerNumber: undefined,
    ObjectClass: undefined,
    CAGEOrDODAAC: undefined,
    CheckDigit: undefined,
    Sku: undefined
  };

  // initialize the bit helper
  const bh = new BitsHelper(epc, 96);

  // make sure the incoming value is really SGTIN by checking the header
  if (bh.bits.slice(0, 8) !== header)
    throw new Error(epc + ' is not a valid SGTIN.');

  // ok, looks good.  parse the stuff we'll need to figure out the rest
  parts.Header = bh.bits.slice(0, 8);
  parts.Filter = parseInt(bh.bits.slice(8, 11), 2);
  parts.Partition = parseInt(bh.bits.slice(11, 14), 2);
  // find the end of the company portion by calculating the number of bits
  // and adding it to the starting offset
  const companyPrefixEnd = 14 + partition.bits.company[parts.Partition];

  // get the company value from the bits, convert to a string
  let company = parseInt(bh.bits.slice(14, companyPrefixEnd), 2).toString();
  // pad the string with leading zeros to make-up the length according to the calculate length
  company = Array(partition.digits.company[parts.Partition] - company.length + 1).join('0') + company;

  parts.CompanyPrefix = company;

  let item = parseInt(bh.bits.slice(companyPrefixEnd, companyPrefixEnd + partition.bits.reference[parts.Partition]), 2).toString();
  item = Array(partition.digits.reference[parts.Partition] - item.length + 1).join('0') + item;

  parts.ItemReference = item;
  parts.SerialNumber = parseInt(bh.bits.slice(58), 2);
  const gs1Key = `${parts.ItemReference.substr(0, 1)}${parts.CompanyPrefix}${parts.ItemReference.substr(1)}`
  parts.CheckDigit = getCheckDigit(gs1Key);
  parts.Sku = `${gs1Key}${parts.CheckDigit}`;
  return parts
}

module.exports = {
  parse,
  encode
}


