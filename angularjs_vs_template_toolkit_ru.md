# AngularJS vs Template Toolkit

date_time: 2014-05-24 20:47:38 MSK

Читаю [tutorial про AngularJS][t]. Кроме всего прочего в AngularJS совершенно
генильный шаблонизатор.

Вот как нужно писать на AngularJS:

    <ul>
        <li ng-repeat="phone in phones">
            {{phone.name}}
            <p>{{phone.snippet}}</p>
        </li>
    </ul>

А вот как бы я написал то же самое с помощью [Template Toolkit][tt]:

    <ul>
        [% FOREACH phone IN phones %]
        <li>
            [% phone.name %]
            <p>[% phone.snippet %]</p>
        </li>
        [% END %]
    </ul>

Версия AngularJS на 2 строчки короче и из-за этого сильно понятнее. Плюс, как
я сейчас понимаю, символы "{{" лучше чем "[%" как минимум в одном — их гораздо
проще набирать на клавиатуре.

 [t]: https://docs.angularjs.org/tutorial/step_02
 [tt]: http://www.template-toolkit.org
