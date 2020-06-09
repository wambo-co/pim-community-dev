<?php

namespace Specification\Akeneo\Pim\Enrichment\Component\Product\Exception;

use Akeneo\Pim\Enrichment\Component\Error\Documented\DocumentationCollection;
use Akeneo\Pim\Enrichment\Component\Error\Documented\DocumentedErrorInterface;
use Akeneo\Pim\Enrichment\Component\Error\Documented\MessageParameterTypes;
use Akeneo\Pim\Enrichment\Component\Error\DomainErrorInterface;
use Akeneo\Pim\Enrichment\Component\Error\TemplatedErrorMessageInterface;
use Akeneo\Pim\Enrichment\Component\Product\Exception\UnknownAttributeException;
use Akeneo\Tool\Component\StorageUtils\Exception\PropertyException;
use PhpSpec\ObjectBehavior;

class UnknownAttributeExceptionSpec extends ObjectBehavior
{
    function let()
    {
        $this->beConstructedWith('attribute_code');
    }

    function it_is_initializable()
    {
        $this->shouldHaveType(UnknownAttributeException::class);
    }

    function it_is_a_property_exception()
    {
        $this->shouldHaveType(PropertyException::class);
    }

    function it_is_an_exception()
    {
        $this->shouldHaveType(\Exception::class);
    }

    function it_is_a_domain_error()
    {
        $this->shouldImplement(DomainErrorInterface::class);
    }

    function it_is_has_a_templated_error_message()
    {
        $this->shouldImplement(TemplatedErrorMessageInterface::class);
    }

    function it_is_a_documented_error()
    {
        $this->shouldImplement(DocumentedErrorInterface::class);
    }

    function it_returns_an_exception_message()
    {
        $this->getMessage()->shouldReturn('The attribute_code attribute does not exist in your PIM.');
    }

    function it_returns_a_property_name()
    {
        $this->getPropertyName()->shouldReturn('attribute_code');
    }

    function it_returns_the_previous_exception()
    {
        $previous = new \Exception();
        $this->beConstructedWith('attribute_code', $previous);

        $this->getPrevious()->shouldReturn($previous);
    }

    function it_returns_a_message_template()
    {
        $this->getMessageTemplate()->shouldReturn('The %s attribute does not exist in your PIM.');
    }

    function it_returns_message_parameters()
    {
        $this->getMessageParameters()->shouldReturn(['attribute_code']);
    }

    function it_provides_documentation()
    {
        $collection = $this->getDocumentation();
        $collection->shouldBeAnInstanceOf(DocumentationCollection::class);
        $collection->normalize()->shouldReturn([
            [
                'message' => 'More information about attributes: {what_is_attribute} {manage_attribute}.',
                'parameters' => [
                    'what_is_attribute' => [
                        'type' => MessageParameterTypes::HREF,
                        'href' => 'https://help.akeneo.com/pim/serenity/articles/what-is-an-attribute.html',
                        'title' => 'What is an attribute?',
                    ],
                    'manage_attribute' => [
                        'type' => MessageParameterTypes::HREF,
                        'href' => 'https://help.akeneo.com/pim/serenity/articles/manage-your-attributes.html',
                        'title' => 'Manage your attributes',
                    ],
                ]
            ],
            [
                'message' => 'Please check your {attribute_settings}.',
                'parameters' => [
                    'attribute_settings' => [
                        'type' => MessageParameterTypes::ROUTE,
                        'route' => 'pim_enrich_attribute_index',
                        'routeParameters' => [],
                        'title' => 'Attributes settings',
                    ],
                ]
            ]
        ]);
    }
}
