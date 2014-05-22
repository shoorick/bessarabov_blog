# Работа с git svn

date_time: 2014-05-22 11:27:05 MSK

Я долго жил на svn и не мог понять, почему все так хвалят git. В конце концов
я перешел на git и действительно, по сравнению с svn, он прекрасен (хотя у
гита есть свои недостатки).

Сейчас мне совершенно не хочется работать с svn и чаще всего я с ним и не
работаю. Но иногда попадаются старые проекты, которые все еще используют svn и
мне приходится использовать svn.

Вообщем мне совсем надоело использовать svn, и я решил разобратся как же
работать с svn с помощью git.

## Создание тестового стенда

    $ svnadmin create sample_repo

    $ svn co file:///home/bessarabov/sample_repo/ tmp_svn
    Checked out revision 0.

    $ cd tmp_svn/

    $ touch README

    $ svn add README
    A         README

    $ svn ci -m 'Initial commit'
    Adding         README
    Transmitting file data .
    Committed revision 1.

    $ svn up
    At revision 1.

    $ svn log
    ------------------------------------------------------------------------
    r1 | bessarabov | 2014-05-20 06:56:25 +0000 (Tue, 20 May 2014) | 1 line

    Initial commit
    ------------------------------------------------------------------------

## Простое клонирование svn через git-svn

    $ git svn clone file:///home/bessarabov/sample_repo/ tmp_git
    Initialized empty Git repository in /home/bessarabov/tmp_git/.git/
            A       README
    r1 = 4863e35a07b240b5f47d0cdb152aa637c82cc4db (refs/remotes/git-svn)
    Checked out HEAD:
      file:///home/bessarabov/sample_repo r1

    $ cd tmp_git
    $ git log
    commit 4863e35a07b240b5f47d0cdb152aa637c82cc4db
    Author: bessarabov <bessarabov@08e19b5c-d886-4fa2-aa5f-3c3df5b527ba>
    Date:   Tue May 20 06:56:25 2014 +0000

        Initial commit

        git-svn-id: file:///home/bessarabov/sample_repo@1 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

Проблема: email автора какой-то уж слишком странный.

## Клонирование svn через git-svn + user mapping

Создаю файл ~/svn_users с таким содержимым:

    bessarabov = Ivan Bessarabov <ivan@bessarabov.ru>

А потом:

    $ mkdir tmp_git
    $ cd tmp_git
    $ git svn init file:///home/bessarabov/sample_repo/
    $ git config svn.authorsfile ~/svn_users
    $ git svn fetch
            A       README
    r1 = 94f0c475fd50a36b089c91b20dd347decbf5e632 (refs/remotes/git-svn)
    Checked out HEAD:
      file:///home/bessarabov/sample_repo r1

    $ git log
    commit 94f0c475fd50a36b089c91b20dd347decbf5e632
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 06:56:25 2014 +0000

        Initial commit

        git-svn-id: file:///home/bessarabov/sample_repo@1 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

## Закомитить в svn с помощью git

Комичу в git:

    $ cd tmp_git
    $ touch a1
    $ git add a1
    $ git commit -m 'Added file a1'
    [master 48836b8] Added file a1
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 a1

    $ touch a2
    $ git add a2
    $ git commit -m 'Added file a2'
    [master 351142b] Added file a2
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 a2

А потом отправляю все в svn:

    $ git svn dcommit
    Committing to file:///home/bessarabov/sample_repo ...
            A       a1
    Committed r2
            A       a1
    r2 = 9863ee5ff395a44760616c8f2cd6de90995940dd (refs/remotes/git-svn)
            A       a2
    Committed r3
            A       a2
    r3 = 270f0581222b1aa38079b7b30d18c8f31b96255a (refs/remotes/git-svn)
    No changes between 351142b8642a52fc8d2fe7cc725db0ba24f1866d and refs/remotes/git-svn
    Resetting to the latest refs/remotes/git-svn

И если я сделал svn up в svn репозитории, то я увижу все эти комиты:

    $ svn up
    A    a1
    A    a2
    Updated to revision 3.
    $ svn log
    ------------------------------------------------------------------------
    r3 | bessarabov | 2014-05-20 07:19:49 +0000 (Tue, 20 May 2014) | 1 line

    Added file a2
    ------------------------------------------------------------------------
    r2 | bessarabov | 2014-05-20 07:19:49 +0000 (Tue, 20 May 2014) | 1 line

    Added file a1
    ------------------------------------------------------------------------
    r1 | bessarabov | 2014-05-20 06:56:25 +0000 (Tue, 20 May 2014) | 1 line

    Initial commit
    ------------------------------------------------------------------------

## Конфликты

Ситуация — в svn репозиторий что-то накомитили и в git репозитории, который
является клоном svn репозитория тоже что-то накомитили. И эти изменения
конфликтуют друг с другом.

Комитим в svn:

    $ echo 'svn' > README
    $ svn ci -m 'Added "svn" to README'
    Sending        README
    Transmitting file data .
    Committed revision 4.

Комитим в git:

    $ echo 'git' > README
    $ git add README
    $ git commit -m 'Added "git" to README'
    [master 6694239] Added "git" to README
     1 file changed, 1 insertion(+)

Делаем dcommit:

    $ git svn dcommit
    Committing to file:///home/bessarabov/sample_repo ...

    ERROR from SVN:
    Transaction is out of date: File '/README' is out of date
    W: 6694239ab99bb95c3158959addd9ea3a6819b5a8 and refs/remotes/git-svn differ, using rebase:
    :100644 100644 5664e303b5dc2e9ef8e14a0845d9486ec1920afd e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 M   README
    Current branch master is up to date.
    ERROR: Not all changes have been committed into SVN, however the committed
    ones (if any) seem to be successfully integrated into the working tree.
    Please see the above messages for details.

Для разрешния конфликта подтягиваем все изменения из svn репозитория в git:

    $ git svn rebase
            M       README
    r4 = 56168a02dd084a57b9fa11bbc33fdf062bff69f6 (refs/remotes/git-svn)
    First, rewinding head to replay your work on top of it...
    Applying: Added "git" to README
    Using index info to reconstruct a base tree...
    M       README
    Falling back to patching base and 3-way merge...
    Auto-merging README
    CONFLICT (content): Merge conflict in README
    Failed to merge in the changes.
    Patch failed at 0001 Added "git" to README
    The copy of the patch that failed is found in:
       /home/bessarabov/tmp_git/.git/rebase-apply/patch

    When you have resolved this problem, run "git rebase --continue".
    If you prefer to skip this patch, run "git rebase --skip" instead.
    To check out the original branch and stop rebasing, run "git rebase --abort".

    rebase refs/remotes/git-svn: command returned error: 1


    $ git status
    # rebase in progress; onto 56168a0
    # You are currently rebasing branch 'master' on '56168a0'.
    #   (fix conflicts and then run "git rebase --continue")
    #   (use "git rebase --skip" to skip this patch)
    #   (use "git rebase --abort" to check out the original branch)
    #
    # Unmerged paths:
    #   (use "git reset HEAD <file>..." to unstage)
    #   (use "git add <file>..." to mark resolution)
    #
    #       both modified:   README
    #
    no changes added to commit (use "git add" and/or "git commit -a")

    $ cat README
    <<<<<<< HEAD
    svn
    =======
    git
    >>>>>>> Added "git" to README

Фиксим конфликт:

    $ vim README
    $ git add README
    $ git rebase --continue
    Applying: Added "git" to README

Смотрим что получилось именно то что нужно — git репозиторий представляет из
себя кучу svn комитов, а потом комтит, который есть в git, но которого еще нет
в svn:

    $ git log
    commit 6f78eb25ca8111613df3c2fb6f277d66c21d5915
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:24:43 2014 +0000

        Added "git" to README

    commit 56168a02dd084a57b9fa11bbc33fdf062bff69f6
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:23:34 2014 +0000

        Added "svn" to README

        git-svn-id: file:///home/bessarabov/sample_repo@4 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 270f0581222b1aa38079b7b30d18c8f31b96255a
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:19:49 2014 +0000

        Added file a2

        git-svn-id: file:///home/bessarabov/sample_repo@3 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 9863ee5ff395a44760616c8f2cd6de90995940dd
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:19:49 2014 +0000

        Added file a1

        git-svn-id: file:///home/bessarabov/sample_repo@2 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 94f0c475fd50a36b089c91b20dd347decbf5e632
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 06:56:25 2014 +0000

        Initial commit

        git-svn-id: file:///home/bessarabov/sample_repo@1 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

И темерь можно отправить все в svn:

    $ git svn dcommit
    Committing to file:///home/bessarabov/sample_repo ...
            M       README
    Committed r5
            M       README
    r5 = 57f7524add88e22d41f8891d0db4c887c531b8fd (refs/remotes/git-svn)
    No changes between 6f78eb25ca8111613df3c2fb6f277d66c21d5915 and refs/remotes/git-svn
    Resetting to the latest refs/remotes/git-svn

И теперь история git выглядит так (обратите внимание что sha1 комита поменялся
после отправки его в svn):

    $ git log
    commit 57f7524add88e22d41f8891d0db4c887c531b8fd
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:32:35 2014 +0000

        Added "git" to README

        git-svn-id: file:///home/bessarabov/sample_repo@5 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 56168a02dd084a57b9fa11bbc33fdf062bff69f6
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:23:34 2014 +0000

        Added "svn" to README

        git-svn-id: file:///home/bessarabov/sample_repo@4 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 270f0581222b1aa38079b7b30d18c8f31b96255a
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:19:49 2014 +0000

        Added file a2

        git-svn-id: file:///home/bessarabov/sample_repo@3 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 9863ee5ff395a44760616c8f2cd6de90995940dd
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 07:19:49 2014 +0000

        Added file a1

        git-svn-id: file:///home/bessarabov/sample_repo@2 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

    commit 94f0c475fd50a36b089c91b20dd347decbf5e632
    Author: Ivan Bessarabov <ivan@bessarabov.ru>
    Date:   Tue May 20 06:56:25 2014 +0000

        Initial commit

        git-svn-id: file:///home/bessarabov/sample_repo@1 08e19b5c-d886-4fa2-aa5f-3c3df5b527ba

## Дополения

### Склонировать только часть комитов

Если svn репозиторий большой, то git svn clone будет работать долго. Обычно
вся svn история не нужна, поэтому можно использовать команду вида:

    git svn clone -r1234:HEAD http://some/svn/repo .

Решение взято со [stackoverflow][so].

## Команды

Притащищить в git изменения из svn:

    $ git svn rebase

Закомитить в svn:

    $ git svn dcommit

 [so]: http://stackoverflow.com/questions/747075/how-to-git-svn-clone-the-last-n-revisions-from-a-subversion-repository
