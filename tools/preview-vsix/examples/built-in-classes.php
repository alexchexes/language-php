<!-- 
To output all:

php -r '
$all = array_merge(
    get_declared_classes(),
    get_declared_interfaces(),
    get_declared_traits()
);

$plain = [];
$namespaced = [];

foreach ($all as $name) {
    $r = new ReflectionClass($name);
    if (!$r->isInternal()) {
        continue;
    }

    // canonical casing instead of alias casing quirks:
    $name = $r->getName();

    if (strpos($name, "\\") === false) {
        $plain[] = $name;
    } else {
        $namespaced[] = $name;
    }
}

sort($plain, SORT_STRING);
sort($namespaced, SORT_STRING);

echo "// [class-like built-ins, non-namespaced]\n";
foreach ($plain as $name) {
    echo "$name::class;\n";
}

echo "\n// [class-like built-ins, namespaced]\n";
foreach ($namespaced as $name) {
    echo "$name::class;\n";
}
'

// Temporary assing a distinct bright color to non-built-ins in VS Code settings.json:
// { "scope": "support.class.php", "settings": { "foreground": "#ff00f7"} },

-->

<?php

// User-defined:
class FooBar {}
FooBar::class;

// Built-in:

// [class-like built-ins, non-namespaced]
AddressInfo::class;
AllowDynamicProperties::class;
AppendIterator::class;
ArgumentCountError::class;
ArithmeticError::class;
ArrayAccess::class;
ArrayIterator::class;
ArrayObject::class;
AssertionError::class;
Attribute::class;
BackedEnum::class;
BadFunctionCallException::class;
BadMethodCallException::class;
CURLFile::class;
CURLStringFile::class;
CachingIterator::class;
CallbackFilterIterator::class;
ClosedGeneratorException::class;
Closure::class;
Collator::class;
CompileError::class;
Countable::class;
CurlHandle::class;
CurlMultiHandle::class;
CurlShareHandle::class;
DOMAttr::class;
DOMCdataSection::class;
DOMCharacterData::class;
DOMChildNode::class;
DOMComment::class;
DOMDocument::class;
DOMDocumentFragment::class;
DOMDocumentType::class;
DOMElement::class;
DOMEntity::class;
DOMEntityReference::class;
DOMException::class;
DOMException::class;
DOMImplementation::class;
DOMNameSpaceNode::class;
DOMNamedNodeMap::class;
DOMNode::class;
DOMNodeList::class;
DOMNotation::class;
DOMParentNode::class;
DOMProcessingInstruction::class;
DOMText::class;
DOMXPath::class;
DateError::class;
DateException::class;
DateInterval::class;
DateInvalidOperationException::class;
DateInvalidTimeZoneException::class;
DateMalformedIntervalStringException::class;
DateMalformedPeriodStringException::class;
DateMalformedStringException::class;
DateObjectError::class;
DatePeriod::class;
DateRangeError::class;
DateTime::class;
DateTimeImmutable::class;
DateTimeInterface::class;
DateTimeZone::class;
DeflateContext::class;
Deprecated::class;
Directory::class;
DirectoryIterator::class;
DivisionByZeroError::class;
DomainException::class;
EmptyIterator::class;
Error::class;
ErrorException::class;
Exception::class;
FFI::class;
Fiber::class;
FiberError::class;
FilesystemIterator::class;
FilterIterator::class;
GdFont::class;
GdImage::class;
Generator::class;
GlobIterator::class;
HashContext::class;
InfiniteIterator::class;
InflateContext::class;
InternalIterator::class;
IntlBreakIterator::class;
IntlCalendar::class;
IntlChar::class;
IntlCodePointBreakIterator::class;
IntlDateFormatter::class;
IntlDatePatternGenerator::class;
IntlException::class;
IntlGregorianCalendar::class;
IntlIterator::class;
IntlPartsIterator::class;
IntlRuleBasedBreakIterator::class;
IntlTimeZone::class;
InvalidArgumentException::class;
Iterator::class;
IteratorAggregate::class;
IteratorIterator::class;
JsonException::class;
JsonSerializable::class;
LengthException::class;
LibXMLError::class;
LimitIterator::class;
Locale::class;
LogicException::class;
MessageFormatter::class;
MultipleIterator::class;
NoRewindIterator::class;
Normalizer::class;
NumberFormatter::class;
OpenSSLAsymmetricKey::class;
OpenSSLCertificate::class;
OpenSSLCertificateSigningRequest::class;
OutOfBoundsException::class;
OutOfRangeException::class;
OuterIterator::class;
OverflowException::class;
Override::class;
PDO::class;
PDOException::class;
PDORow::class;
PDOStatement::class;
ParentIterator::class;
ParseError::class;
Phar::class;
PharData::class;
PharException::class;
PharFileInfo::class;
PhpToken::class;
PropertyHookType::class;
RangeException::class;
RecursiveArrayIterator::class;
RecursiveCachingIterator::class;
RecursiveCallbackFilterIterator::class;
RecursiveDirectoryIterator::class;
RecursiveFilterIterator::class;
RecursiveIterator::class;
RecursiveIteratorIterator::class;
RecursiveRegexIterator::class;
RecursiveTreeIterator::class;
Reflection::class;
ReflectionAttribute::class;
ReflectionClass::class;
ReflectionClassConstant::class;
ReflectionConstant::class;
ReflectionEnum::class;
ReflectionEnumBackedCase::class;
ReflectionEnumUnitCase::class;
ReflectionException::class;
ReflectionExtension::class;
ReflectionFiber::class;
ReflectionFunction::class;
ReflectionFunctionAbstract::class;
ReflectionGenerator::class;
ReflectionIntersectionType::class;
ReflectionMethod::class;
ReflectionNamedType::class;
ReflectionObject::class;
ReflectionParameter::class;
ReflectionProperty::class;
ReflectionReference::class;
ReflectionType::class;
ReflectionUnionType::class;
ReflectionZendExtension::class;
Reflector::class;
RegexIterator::class;
RequestParseBodyException::class;
ResourceBundle::class;
ReturnTypeWillChange::class;
RoundingMode::class;
RuntimeException::class;
SeekableIterator::class;
SensitiveParameter::class;
SensitiveParameterValue::class;
Serializable::class;
SessionHandler::class;
SessionHandlerInterface::class;
SessionIdInterface::class;
SessionUpdateTimestampHandlerInterface::class;
Shmop::class;
SimpleXMLElement::class;
SimpleXMLIterator::class;
Socket::class;
SodiumException::class;
SplDoublyLinkedList::class;
SplFileInfo::class;
SplFileObject::class;
SplFixedArray::class;
SplHeap::class;
SplMaxHeap::class;
SplMinHeap::class;
SplObjectStorage::class;
SplObserver::class;
SplPriorityQueue::class;
SplQueue::class;
SplStack::class;
SplSubject::class;
SplTempFileObject::class;
Spoofchecker::class;
StreamBucket::class;
Stringable::class;
SysvMessageQueue::class;
SysvSemaphore::class;
SysvSharedMemory::class;
Throwable::class;
Transliterator::class;
Traversable::class;
TypeError::class;
UConverter::class;
UnderflowException::class;
UnexpectedValueException::class;
UnhandledMatchError::class;
UnitEnum::class;
ValueError::class;
WeakMap::class;
WeakReference::class;
XMLParser::class;
XMLReader::class;
XMLWriter::class;
XSLTProcessor::class;
ZipArchive::class;
__PHP_Incomplete_Class::class;
finfo::class;
php_user_filter::class;
stdClass::class;

// [class-like built-ins, namespaced]
BcMath\Number::class;
Dom\AdjacentPosition::class;
Dom\Attr::class;
Dom\CDATASection::class;
Dom\CharacterData::class;
Dom\ChildNode::class;
Dom\Comment::class;
Dom\Document::class;
Dom\DocumentFragment::class;
Dom\DocumentType::class;
Dom\DtdNamedNodeMap::class;
Dom\Element::class;
Dom\Entity::class;
Dom\EntityReference::class;
Dom\HTMLCollection::class;
Dom\HTMLDocument::class;
Dom\HTMLElement::class;
Dom\Implementation::class;
Dom\NamedNodeMap::class;
Dom\NamespaceInfo::class;
Dom\Node::class;
Dom\NodeList::class;
Dom\Notation::class;
Dom\ParentNode::class;
Dom\ProcessingInstruction::class;
Dom\Text::class;
Dom\TokenList::class;
Dom\XMLDocument::class;
Dom\XPath::class;
FFI\CData::class;
FFI\CType::class;
FFI\Exception::class;
FFI\ParserException::class;
FTP\Connection::class;
IMAP\Connection::class;
Pcntl\QosClass::class;
Pdo\Pgsql::class;
PgSql\Connection::class;
PgSql\Lob::class;
PgSql\Result::class;
Random\BrokenRandomEngineError::class;
Random\CryptoSafeEngine::class;
Random\Engine::class;
Random\Engine\Mt19937::class;
Random\Engine\PcgOneseq128XslRr64::class;
Random\Engine\Secure::class;
Random\Engine\Xoshiro256StarStar::class;
Random\IntervalBoundary::class;
Random\RandomError::class;
Random\RandomException::class;
Random\Randomizer::class;
