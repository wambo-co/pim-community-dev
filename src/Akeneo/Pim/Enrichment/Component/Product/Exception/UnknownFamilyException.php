<?php

namespace Akeneo\Pim\Enrichment\Component\Product\Exception;

use Akeneo\Pim\Enrichment\Component\Error\Documented\Documentation;
use Akeneo\Pim\Enrichment\Component\Error\Documented\DocumentationCollection;
use Akeneo\Pim\Enrichment\Component\Error\Documented\DocumentedErrorInterface;
use Akeneo\Pim\Enrichment\Component\Error\Documented\HrefMessageParameter;
use Akeneo\Pim\Enrichment\Component\Error\Documented\RouteMessageParameter;
use Akeneo\Pim\Enrichment\Component\Error\DomainErrorInterface;
use Akeneo\Pim\Enrichment\Component\Error\TemplatedErrorMessageInterface;
use Akeneo\Tool\Component\StorageUtils\Exception\InvalidPropertyException;

/**
 * @copyright 2020 Akeneo SAS (http://www.akeneo.com)
 * @license   http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */
final class UnknownFamilyException extends InvalidPropertyException implements
    DomainErrorInterface,
    TemplatedErrorMessageInterface,
    DocumentedErrorInterface
{
    /** @var string */
    private $messageTemplate;

    /** @var array */
    private $messageParameters;

    public function __construct(string $propertyName, string $propertyValue, string $className)
    {
        $this->messageTemplate = 'The %s family does not exist in your PIM.';
        $this->messageParameters = [$propertyValue];

        parent::__construct(
            $propertyName,
            $propertyValue,
            $className,
            sprintf($this->messageTemplate, ...$this->messageParameters),
            self::VALID_ENTITY_CODE_EXPECTED_CODE
        );
    }

    public function getMessageTemplate(): string
    {
        return $this->messageTemplate;
    }

    public function getMessageParameters(): array
    {
        return $this->messageParameters;
    }

    public function getDocumentation(): DocumentationCollection
    {
        return new DocumentationCollection([
            new Documentation(
                'Please check your {family_settings}.',
                [
                    'family_settings' => new RouteMessageParameter(
                        'Family settings',
                        'pim_enrich_family_index'
                    )
                ]
            ),
            new Documentation(
                'More information about families: {what_is_a_family} {manage_your_families}.',
                [
                    'what_is_a_family' => new HrefMessageParameter(
                        'What is a family?',
                        'https://help.akeneo.com/pim/serenity/articles/what-is-a-family.html'
                    ),
                    'manage_your_families' => new HrefMessageParameter(
                        'Manage your families',
                        'https://help.akeneo.com/pim/serenity/articles/manage-your-families.html'
                    )
                ]
            )
        ]);
    }
}
